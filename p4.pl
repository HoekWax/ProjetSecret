max(X,Y,Y) :- Y>X, !.
max(X,_,X). 

% affichage de grille https://github.com/piclemx/ift-2003/blob/master/tp2/nouvelleGrille.pl

% lancerIA. et jouer. à renommer en 1v1 et 1vIA par exemple. pour le 1v1, afficher la grille vide au début
% Quand l'ia gagne, la game continue, A FIXER

% ctrl f et tt remplacer
% Changer tous les texte (celui ci à gagné, c'est à lui de jouer etc)
% Voir les fonctions heurstiques (pourquoi faire un move et pas un autre pour win par exemple, voir la valeur des coups)
% Mettre la page de garde de marketing sur le drive
% Diviser en plusieurs fichier (un main, un setup etats etc, fonctions utiles (ajouter fin de liste), affichage de grille, evaluation de la fin du jeu).
% Revoir l'affichage de la grille et mettre les numero de lignes, refaire tous les commentaires
% renommer les fonctions en anglais (play_game_o etc)
% renommer les variables (L en LIST, G en BOARD)
% réorganiser les blocs de code
% VIRER TOUS LES WARNING
% Afficher la colonne à laquelle l'IA joue (ex: IA a joué o sur la colone 3.)
% Voir comment marche l'IA, min/max ou hill climbbing ou autre

% Fonction qui permet d'ajouter un élément en fin de liste
add_to_end(X,[],[X]).
add_to_end(X,[Y|L1],[Y|L2]):- add_to_end(X,L1,L2).

end_of_list([], _).
end_of_list(L, E):- last(L,E).

% Fonction qui renvoie une sous-liste à partir d'une liste L
/* Param�tres : S sous-liste, L liste */
prefix(P,L):-append(P,_,L).
sublist(S,L):-prefix(S,L).
sublist(S,[_|T]):-sublist(S,T).

% Fonction qui retourne la lenght d'une liste
/* Paramètres : L liste, N lenght de la liste */
lenght([],0).
lenght([_|L],N):- lenght(L,N1),
					N is N1+1.

% Fonction qui renvoie le ni�me �l�ment d'une liste 
/* Param�tres : N index de l'�lement qu'on veut r�cup�rer, L liste, X �l�ment retourn� */
get_element_from_index(N, L, []):- lenght(L, N1), N1 < N.
get_element_from_index(N, L, X):- nth1(N, L, X).				

% Fonction qui enregistre un coup jou� dans la grille
/* Param�tres : N num�ro de la colonne dans laquelle J joue, G grille, J joueur, G' nouvelle grille */		
make_move(1, [L|G], x, _, I):- lenght(L,N), N >= 6, write('Coup Invalide\n'), turn_x(I).
make_move(1, [L|G], o, _, I):- lenght(L,N), N >= 6, write('Coup Invalide\n'), turn_o(I).
make_move(1, [L|G], J, F, I):- lenght(L,N), N < 6, add_to_end(J,L,M), F=[M|G].
make_move(N, [L|G], x, _, I):- N > 7, write('Coup Invalide\n'), turn_x(I).
make_move(N, [L|G], o, _, I):- N > 7, write('Coup Invalide\n'), turn_o(I).
make_move(N, [T|X], J, [T|G], I):- 	N > 0,
										N1 is N-1,
										make_move(N1, X, J, G, I).
					
make_move_player(1, [L|G], x, _, I):- lenght(L,N), N >= 6, write('Coup Invalide\n'), player_turn(I).
make_move_player(1, [L|G], J, F, I):- lenght(L,N), N < 6, add_to_end(J,L,M), F=[M|G].
make_move_player(N, [L|G], x, _, I):- N > 7, write('Coup Invalide\n'), player_turn(I).	
make_move_player(N, [T|X], J, [T|G], I):- 	N > 0,
										N1 is N-1,
										make_move_player(N1, X, J, G, I).

make_move_ai(1, [L|G], J, F, I):- lenght(L,N), N < 6, add_to_end(J,L,M), F=[M|G].
make_move_ai(N, [T|X], J, [T|G], I):- 	N > 0,
										N1 is N-1,
										make_move_ai(N1, X, J, G, I).
% Condition de victoire verticale : 4 jetons les uns après les autres sur une même colonne
/* Param�tres : G grille, J joueur */										
check_end_game_vertically([L|_],J):- sublist([J,J,J,J], L),!.
check_end_game_vertically([_|G],J):- check_end_game_vertically(G,J).

% Condition de victoire horizontale : 4 jetons les uns après les autres sur une même ligne
/* Param�tres : N num�ro de la ligne � partir duquel on traite, G grille, J joueur */
check_end_game_horizontally(N, G, J):- maplist(get_element_from_index(N), G, L), 
					 sublist([J,J,J,J],L),!.
check_end_game_horizontally(N, G, J):- N > 0,
					 N1 is N-1,
					 check_end_game_horizontally(N1, G, J).

check_end_game_horizontally(G,J):- check_end_game_horizontally(6, G, J).				 

check_end_game_diagonally_2(G,D,J,0):- sublist([J,J,J,J],D).
check_end_game_diagonally_2(G,D,J,N):- N > 0,
					  maplist(get_element_from_index(N), G, L),
					  get_element_from_index(N,L,E),
					  N1 is N-1,
					  check_end_game_diagonally_2(G,[E|D],J,N1).

check_end_game_diagonally_2(G,J):- check_end_game_diagonally_2(G,[],J,6).

check_end_game_diagonally_1(G,D,J,0):- sublist([J,J,J,J],D).
check_end_game_diagonally_1(G,D,J,N):- N > 0,
					    maplist(get_element_from_index(N), G, L),
						N2 is 7-N,
						get_element_from_index(N2,L,E),
					    N1 is N-1,
					    check_end_game_diagonally_1(G,[E|D],J,N1).

check_end_game_diagonally_1(G,J):- check_end_game_diagonally_1(G,[],J,6).


check_end_game_diagonally(G,N,X,J):- check_end_game_diagonally_1(X,J),!.
check_end_game_diagonally(G,N,X,J):- check_end_game_diagonally_2(X,J),!.
check_end_game_diagonally(G,N,X,J):- N < 7,
					  maplist(get_element_from_index(N), G, L),
					  N1 is N+1,
					  check_end_game_diagonally(G,N1,[L|X],J).

check_end_game_diagonally(G,J):- check_end_game_diagonally(G,1,[],J).

% D�finition et test des conditions de fin de jeu
/* Param�tres : G grille, J joueur */
check_end_game(G, J):- check_end_game_vertically(G,x), J=x.
check_end_game(G, J):- check_end_game_vertically(G,o), J=o.
check_end_game(G, J):- check_end_game_horizontally(G,x), J=x.
check_end_game(G, J):- check_end_game_horizontally(G,o), J=o.
check_end_game(G, J):- check_end_game_diagonally(G,x), J=x.
check_end_game(G, J):- check_end_game_diagonally(G,o), J=o.

% Affichage du gagnant
/* Param�tres : J joueur */
write_winner(J):-write('Le Joueur '), write(J), write(' a gagné !').

/* Param�tres : G grille*/
turn_x(G):-check_end_game(G,J), write_winner(J),!.
turn_o(G):-check_end_game(G,J), write_winner(J),!.
turn_x(G):- write('Joueur x, entrez un numéro de colonne :'), nl,
				read(N), make_move(N,G, x, X, G),
				afficherGrille(X),
				write('\n'),
				turn_o(X).
turn_o(G):- write('Joueur o, entrez un numéro de colonne :'), nl,
				read(N), make_move(N,G, o, X, G),
				afficherGrille(X),
				write('\n'),
				turn_x(X).

% Lancement du jeu : grille de d�part de 6*7 (vide). C'est le joueur 'o' qui commence, suivi par x, jusqu'� ce que l'un des deux gagne [ou GRILLE PLEINE]
play:- turn_o([[],[],[],[],[],[],[]]).

%Un coup gagant est un coup qui mene à un état de jeu ou le joueur est vainqueur
winning_move(C,G,J):- make_move_ai(1,G,J,N,G), check_end_game(N,J), C=1.
winning_move(C,G,J):- make_move_ai(2,G,J,N,G), check_end_game(N,J), C=2.
winning_move(C,G,J):- make_move_ai(3,G,J,N,G), check_end_game(N,J), C=3.
winning_move(C,G,J):- make_move_ai(4,G,J,N,G), check_end_game(N,J), C=4.
winning_move(C,G,J):- make_move_ai(5,G,J,N,G), check_end_game(N,J), C=5.
winning_move(C,G,J):- make_move_ai(6,G,J,N,G), check_end_game(N,J), C=6.
winning_move(C,G,J):- make_move_ai(7,G,J,N,G), check_end_game(N,J), C=7.

%Un coup perdant est un coup qui permet à l'adversaire de gagner
losing_move(1,G):- make_move_ai(1,G,o,N,G), winning_move(_,N,x).
losing_move(2,G):- make_move_ai(2,G,o,N,G), winning_move(_,N,x).
losing_move(3,G):- make_move_ai(3,G,o,N,G), winning_move(_,N,x).
losing_move(4,G):- make_move_ai(4,G,o,N,G), winning_move(_,N,x).
losing_move(5,G):- make_move_ai(5,G,o,N,G), winning_move(_,N,x).
losing_move(6,G):- make_move_ai(6,G,o,N,G), winning_move(_,N,x).
losing_move(7,G):- make_move_ai(7,G,o,N,G), winning_move(_,N,x).

player_turn(G):-check_end_game(G,J), write_winner(J),!.
ai_turn(G):-check_end_game(G,J), write_winner(J),!.

%Si un coup permet de gagner il faut le jouer.
ai_turn(G):-   winning_move(C,G,o), make_move_ai(C,G,o,X,G),
			   afficherGrille(X),
			   write('\n'),
			   player_turn(X).

%Si un coup permet a l'adversaire de gagner on se défend(coup défensif).
ai_turn(G):-   winning_move(C,G,x), make_move_ai(C,G,o,X,G),
			   afficherGrille(X),
			   write('\n'),
			   player_turn(X).

ai_turn(0, G):- write('Pas de coup trouvé').


ai_turn(C, G):- make_move_ai(C,G,o,X,G),
			    afficherGrille(X),
			    write('\n'),
			    player_turn(X).

space_left(1, [L|G], E, L):- lenght(L,N2), N3 is 6-N2, E=N3.
space_left(N, [T|X], E, L):- N > 0,
								N1 is N-1,
								space_left(N1, X, E, L).
									
%Si on a pas de coup immédiat on fait un coup au centre ou au plus près possible pour une victoire possible en verticale.
ai_turn(G):- space_left(4,G,E,L), end_of_list(L,o), E > 3, not(losing_move(4,G)), ai_turn(4,G).
ai_turn(G):- space_left(5,G,E,L), end_of_list(L,o), E > 3, not(losing_move(5,G)), ai_turn(5,G).
ai_turn(G):- space_left(3,G,E,L), end_of_list(L,o), E > 3, not(losing_move(3,G)), ai_turn(3,G).
ai_turn(G):- space_left(6,G,E,L), end_of_list(L,o), E > 3, not(losing_move(6,G)), ai_turn(6,G).
ai_turn(G):- space_left(2,G,E,L), end_of_list(L,o), E > 3, not(losing_move(2,G)), ai_turn(2,G).
ai_turn(G):- space_left(7,G,E,L), end_of_list(L,o), E > 3, not(losing_move(7,G)), ai_turn(7,G).
ai_turn(G):- space_left(1,G,E,L), end_of_list(L,o), E > 3, not(losing_move(1,G)), ai_turn(1,G).

%Sinon jouer au plus près du centre quand même.
ai_turn(G):- ai_turn(4,G),not(losing_move(4,G)).
ai_turn(G):- ai_turn(5,G),not(losing_move(5,G)).
ai_turn(G):- ai_turn(3,G),not(losing_move(3,G)).
ai_turn(G):- ai_turn(6,G),not(losing_move(6,G)).
ai_turn(G):- ai_turn(2,G),not(losing_move(2,G)).
ai_turn(G):- ai_turn(7,G),not(losing_move(7,G)).
ai_turn(G):- ai_turn(1,G),not(losing_move(1,G)).

%Déblocage de situation
ai_turn(G):- ai_turn(4,G).
ai_turn(G):- ai_turn(5,G).
ai_turn(G):- ai_turn(3,G).
ai_turn(G):- ai_turn(6,G).
ai_turn(G):- ai_turn(2,G).
ai_turn(G):- ai_turn(7,G).
ai_turn(G):- ai_turn(1,G).
ai_turn(G):- ai_turn(0,G).

player_turn(G):- write('Joueur x, entrez un numéro de colonne :'), nl,
				read(N), make_move_player(N,G, x, X, G),
				afficherGrille(X),
				write('\n'),
				ai_turn(X).

play_ai:- ai_turn([[],[],[],[],[],[],[]]).

/*enregistrerCoupArbre(1, [L|G], J, [[J|L]|G]):- lenght(L,N), N < 6.
enregistrerCoupArbre(N, [T|X], J, [T|G]):- 	N > 0,
										N1 is N-1,
										enregistrerCoupArbre(N1, X, J, G).*/
% Evaluation de la grille de jeu
/* Paramètres : G grille, J joueur */
/*evalVert([], _, P, X):- X=P, write(fini).										
evalVert([L|G],J, P, X):- 	sublist([J,J,J,J], L),
							evalVert(G, J, P, 4, X).
evalVert([L|G],J, P, X):- 	sublist([J,J,J], L),
							evalVert(G, J, P, 3, X).
evalVert([L|G],J, P, X):- 	sublist([J,J], L),
							evalVert(G, J, P, 2, X).
evalVert([L|G],J, P, X):- evalVert(G, J, P, 1, X).
evalVert(G,J, P1, P2, X):- 	max(P1, P2, P),
							evalVert(G, J, P, X).
evalVert(G, J, X):- evalVert(G,J, 0, 1, X).*/

/* Paramètres : N numéro de la ligne à partir duquel on traite, G grille, J joueur */
/*evalHor(_,[],J,P):- write(fini).
evalHor(N, G, J, P):- maplist(get_element_from_index(N), G, L), 
					 sublist([J,J,J,J],L),
					 evalHor(N, G, J, P, 4).
evalHor(N, G, J, P):- maplist(get_element_from_index(N), G, L), 
					 sublist([J,J,J],L),
					 evalHor(N, G, J, P, 3).
evalHor(N, G, J, P):- maplist(get_element_from_index(N), G, L), 
					 sublist([J,J],L),
					 evalHor(N, G, J, P, 2).
evalHor(N, G, J, P):- maplist(get_element_from_index(N), G, L), 
					 sublist([J],L),
					 evalHor(N, G, J, P, 1).
evalHor(N, G, J, P1, P2):- N > 0,
					 N1 is N-1,
					 write(toto),
					 max(P1, P2, P),
					 evalHor(N1, G, J, P),
					 write(P).
evalHor(G,J,P):- evalHor(6, G, J, 0, 1).

evalGrille(G, J, X) :- evalHor(G,J,P1),
					evalVert(G, J, P2),	
					max(P1,P2, X).		*/						
										
/* Paramètres : G grille, J joueur, P profondeur, A arbre obtenu */
/*tracerArbre(G, J, 0, A).
tracerArbre(G, J, P, A):- P > 0,
					      P1 is P-1,
						  tracerBranche(G, J, P1, A, 7).

tracerBranche(G, J, P, A, 1).						  
tracerBranche(G, x, P, A, N):- N > 0,
							   N1 is N-1,
							   enregistrerCoupArbre(N, G, x, X), 
							   tracerArbre(X, o, P, A),
							   tracerBranche(G, x, P, A, N1).			
tracerBranche(G, o, P, A, N):- N > 0,
							   N1 is N-1,
							   enregistrerCoupArbre(N, G, o, X), 
							   tracerArbre(X, x, P, A),
							   tracerBranche(G, o, P, A, N1).*/
afficherGrille(_,0).							   
afficherGrille(G, N):-	 N > 0,
						N1 is N-1,
						maplist(get_element_from_index(N), G, L),
						afficherListe(L),
						afficherGrille(G, N1).

afficherGrille(G):- afficherGrille(G,6).
 
afficherListe([]):- write('|\n').
afficherListe([E|L]):-  write('|'), 
						afficherElement(E),
						afficherListe(L).
afficherElement([]):- write(' '),!.
afficherElement(E):- write(E).
