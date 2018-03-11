%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% resolveur du taquin (Technique du Hill-Climbing)
%% La question a poser est : ?- resolveur( Deplacements ).
% Deplacements donne tous les deplacements a faire pour atteindre la situation finale
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
resolveur(Deplacements ) :-
    configuration_initiale( CI),
    configuration_finale(CF),
    resoudre_hill_climbing(CI, CF, [CI], Deplacements ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Hill Climbing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

resoudre_hill_climbing( Configuration, Configuration, _, [] ).
resoudre_hill_climbing( Configuration, ConfigurationFinale, Deja_generees, [Deplacement | Deplacements] ) :-
    trouver_deplacements_legaux( Depls_Possibles, Configuration ),
    generer_configurations( Depls_Possibles, Configuration, ListeConfigurations ),
    valider( ListeConfigurations, Depls_Possibles, Deja_generees, ListeConfsValides, DeplsValides ),
    valeur_HC_tous( ListeConfsValides, ConfigurationFinale, ListeValeurs ),
    faire_liste( ListeValeurs, DeplsValides, ListeConfsValides, ListeConfsValuees ),
    trier( ListeConfsValuees, ListeConfsTriees ),
    member( [ V, Deplacement, NouvelleConf ], ListeConfsTriees ),
    resoudre_hill_climbing( NouvelleConf, ConfigurationFinale, [NouvelleConf | Deja_generees], Deplacements ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Predicats necessaires au jeu du taquin
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Situation de depart et situation a atteindre
configuration_initiale([1,*,4,8,3,5,7,2,6]).
configuration_finale([1,4,5,8,3,*,7,2,6]).

% Les deplacements possibles de lasteristique
deplacer( deplacer_vers_gauche, De, A ) :- A is De - 1.
deplacer( deplacer_vers_haut, De, A ) :- A is De - 3.
deplacer( deplacer_vers_droite, De, A ) :- A is De + 1.
deplacer( deplacer_vers_bas, De, A ) :- A is De + 3.
% Les contraintes du jeu (ne pas sortir des 9 positions possibles
contraintes( deplacer_vers_gauche, [1, 4, 7] ).
contraintes( deplacer_vers_haut, [1, 2, 3] ).
contraintes( deplacer_vers_droite, [3, 6, 9] ).
contraintes( deplacer_vers_bas, [7, 8, 9] ).

% Determine le premier deplacement possible (gauche, haut, droit, bas)
trouver_deplacement_legal( Deplacement, Configuration ) :-
    position_element( Configuration, '*', P),
    contraintes( Deplacement, C),
    not( member( P, C ) ).



% Determine tous les deplacements legaux qui s appliquent a une configuration
trouver_deplacements_legaux( Deplacements, Configuration ) :-
    findall( X, trouver_deplacement_legal( X, Configuration ), Deplacements ).
% Permet de generer une nouvelle configuration (C2) a partir dune autre (C1) en appliquant Deplacement
generer( Deplacement, C1, C2 ) :-
    position_element( C1, '*', P ),
    deplacer( Deplacement, P, P1 ),
    element_position( C1, Element, P1 ),
    remplacer( P1, '*', C1, C3 ),
    remplacer( P, Element, C3, C2 ).
% Determine toutes les configurations obtenues a partir d une configuration en appliquant la liste des deplacements
generer_configurations( [], Configuration, [] ).
generer_configurations( [ Deplacement | Deplacements ], Configuration, [ Config | Configs ] ) :-
    generer( Deplacement, Configuration, Config ),
    generer_configurations( Deplacements, Configuration, Configs ).
% Si une configuration a deja ete generee, on la rejette ainsi que le deplacement associe
valider( [], _, _, [], [] ).
valider( [ C | Configurations ], [ D | Deplacements ], Deja_generees, [C | Configs], [D | Depls] ) :-
    not( member( C, Deja_generees ) ),!,
    valider( Configurations, Deplacements, Deja_generees, Configs, Depls ).
valider( [ C | Configurations ], [ D | Deplacements ], Deja_generees, Configs, Depls ) :-
    valider( Configurations, Deplacements, Deja_generees, Configs, Depls ).
% Calcul de la valeur de la fonction heuristique
valeur_HC_tous( [], _, [] ).
valeur_HC_tous( [C|Configs], CF, [V|Valeurs] ) :-
    valeur_HC( C, CF, V ),
    valeur_HC_tous( Configs, CF, Valeurs ).

valeur_HC( [], [], 0 ) :- !.
valeur_HC( [X | Xs], [X | Ys], V_HC ) :-
    valeur_HC( Xs, Ys, V_HC ), !.
valeur_HC( [X | Xs], [Y | Ys], V_HC ) :-
    valeur_HC( Xs, Ys, V_HC1 ), V_HC is V_HC1 + 1.

% faire une seule liste de triplet a partir de trois listes
faire_liste( [], [], [], [] ).
faire_liste( [X | Xs], [Y | Ys], [Z | Zs], [[X,Y,Z] | Reste] ) :-
    faire_liste( Xs, Ys, Zs, Reste ).
% trier (algorithme de tri QuickSort)
trier( [], [] ).
trier( [X|Reste], ListeTriee ) :-
    partitionner( Reste, X, Les_Petits, Les_Grands ),
    trier( Les_Petits, Ps ),
    trier( Les_Grands, Gs ),
    append( Ps, [X | Gs], ListeTriee ).

partitionner( [], _, [], [] ).
partitionner( [ [X1,X2,X3] | Xs], [Y1,Y2,Y3], [ [X1,X2,X3] | Ps], Gs ) :-
    X1 < Y1, !,
    partitionner( Xs, [Y1,Y2,Y3], Ps, Gs).


partitionner( [ [X1,X2,X3] | Xs], [Y1,Y2,Y3], Ps, [ [X1,X2,X3] | Gs] ) :-
    partitionner( Xs, [Y1,Y2,Y3], Ps, Gs).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Predicats de service
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% position_element/3 : recherche la position d un element dans une liste
position_element( [ Element | _ ], Element, 1 ) :- !.
position_element( [ _ | Reste ], Element, P ) :- position_element( Reste, Element, NP ), P is NP + 1.
% element_position/3 : recherche l element a une position donnee dans une liste
element_position( [ Element | _ ], Element, 1 ) :- !.
element_position( [ _ | Reste ], Element, P ) :- NP is P - 1, element_position( Reste, Element, NP).
% remplacer/3 : remplace un enieme element d une liste par un autre
remplacer( 1, Nouveau, [ Element | Reste ], [ Nouveau | Reste ] ) :- !.
remplacer( N, Nouveau, [ Element | Reste ], [ Element | Final ] ) :-
    NP is N - 1, remplacer( NP, Nouveau, Reste, Final ).



