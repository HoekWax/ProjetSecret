

% affichage de grille https://github.com/piclemx/ift-2003/blob/master/tp2/nouvelleGrille.pl

% OK - ctrl f et tt remplacer
% OK - Changer tous les texte (celui ci à gagné, c'est à lui de jouer etc)
% OK - Voir les fonctions heurstiques (pourquoi faire un move et pas un autre pour win par exemple, voir la valeur des coups)
% OK - Mettre la page de garde de marketing sur le drive
% OK - Revoir l'affichage de la grille et mettre les numero de lignes, refaire tous les commentaires
% OK - Refaire tous les commentaires
% OK - renommer les fonctions en anglais (play_game_o etc)
% OK - Afficher la colonne à laquelle l'IA joue (ex: IA a joué o sur la colonne 3.)
% OK - Voir comment marche l'IA, min/max ou hill climbbing ou autre

% Changer G Grille en P Plateau, J en Joueur (comme dans son exemple de Taquin)
% Régler le pb du check en diagonale
% Fichiers : Check_fin_game, print.pl, AI.pl, utils.pls, player.pl
% Quand l'ia gagne, la game continue, A FIXER
% Quand on arrive à impossible de jouer ce coup ou ce genre de chose ça nique tout pour l'affichage du jeu
% renommer les variables (L en LIST, G en BOARD)
% réorganiser les blocs de code
% OK - VIRER TOUS LES WARNING
% Diviser en plusieurs fichier (un main, un setup etats etc, fonctions utiles (ajouter fin de liste), affichage de grille, evaluation de la fin du jeu).

:- consult(utils).
:- consult(check_end_game).
:- consult(print).
:- consult(onevsone).
:- consult(onevsia).

% play affiche la grille de jeu et démarre un 1 contre 1, le joueur o commence
play:- print_board([[],[],[],[],[],[],[]]), nl, turn_o([[],[],[],[],[],[],[]]).

% play_ai démarre un 1 contre ia, l'ia commence
play_ai:- turn_ai([[],[],[],[],[],[],[]]).
