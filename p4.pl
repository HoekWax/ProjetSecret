

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

% Régler le pb du check en diagonale
% Fichiers : Check_fin_game, print.pl, AI.pl, utils.pls, player.pl
% Quand l'ia gagne, la game continue, A FIXER
% Quand on arrive à impossible de jouer ce coup ou ce genre de chose ça nique tout pour l'affichage du jeu
% renommer les variables (L en LIST, G en BOARD)
% réorganiser les blocs de code
% VIRER TOUS LES WARNING
% Diviser en plusieurs fichier (un main, un setup etats etc, fonctions utiles (ajouter fin de liste), affichage de grille, evaluation de la fin du jeu).


% add_to_end/3 ajoute une valeur à la fin d'une liste (Params : 1er = valeur, 2e = liste, 3e = liste retournée)
add_to_end(X,Y,Z) :- append(Y,[X],Z).

% end_of_list/2 vérifie que le dernier élément de L est égal à E (Params : L = liste, E = élément)
end_of_list([], _).
end_of_list(L, E):- last(L,E).

% sublist/2 retourne une sous-liste de L (Params : S = sous-liste, L = liste)
prefix(P,L):-append(P,_,L).
sublist(S,L):-prefix(S,L).
sublist(S,[_|T]):-sublist(S,T).


% lenght/2 retourne la longueur de la liste L (Params : L = liste, N = longueur)
lenght([],0).
lenght([_|L],N):- lenght(L,N1),
					N is N1+1.

% get_element_from_index/3 retourne l'élément d'une liste à partir d'un index donné (Params : IDX = index, L = liste, E = élément)
get_element_from_index(IDX, L, []):- lenght(L, N1), N1 < IDX.
get_element_from_index(IDX, L, E):- nth1(IDX, L, E).

% make_move/5 est pour le mode 1 contre 1 et garde en mémoire le coup qui vient d'être joué et affiche une erreur si nécessaire (Params : 1er = colonne, 2e = grille, 3e = joueur, 4e = nouvelle grille, 5e = grille de sauvegarde)	
make_move(1, [L|_], x, _, I):- lenght(L,N), N >= 6, print_impossible_move(), turn_x(I).
make_move(1, [L|_], o, _, I):- lenght(L,N), N >= 6, print_impossible_move(), turn_o(I).
make_move(1, [L|G], J, F, _):- lenght(L,N), N < 6, add_to_end(J,L,M), F=[M|G].
make_move(N, [_|_], x, _, I):- N > 7, print_impossible_move(), turn_x(I).
make_move(N, [_|_], o, _, I):- N > 7, print_impossible_move(), turn_o(I).
make_move(N, [T|X], J, [T|G], I):- 	N > 0,
									N1 is N - 1,
									make_move(N1, X, J, G, I).

% make_move_player/5 est pour le mode contre l'ia et garde en mémoire le coup qui vient d'être joué par le joueur et affiche une erreur si nécessaire (Params : Les mêmes que make_move/5)
make_move_player(1, [L|_], x, _, I):- lenght(L,N), N >= 6, print_impossible_move(), player_turn(I).
make_move_player(1, [L|G], J, F, _):- lenght(L,N), N < 6, add_to_end(J,L,M), F=[M|G].
make_move_player(N, [_|_], x, _, I):- N > 7, print_impossible_move(), player_turn(I).	
make_move_player(N, [T|X], J, [T|G], I):- 	N > 0,
											N1 is N - 1,
											make_move_player(N1, X, J, G, I).

% make_move_ai/5 est pour le mode contre l'ia et garde en mémoire le coup qui vient d'être joué par l'ia et affiche une erreur si nécessaire (Params : Les mêmes que make_move/5)
make_move_ai(1, [L|G], J, F, _):- lenght(L,N), N < 6, add_to_end(J,L,M), F=[M|G].
make_move_ai(N, [T|X], J, [T|G], I):- 	N > 0,
										N1 is N - 1,
										make_move_ai(N1, X, J, G, I).

% check_end_game_vertically/2 vérifie si 4 valeurs sont les mêmes verticalement (Params : 1er = grille, J = joueur)
check_end_game_vertically([L|_],J):- sublist([J,J,J,J], L),!.
check_end_game_vertically([_|G],J):- check_end_game_vertically(G,J).


check_end_game_horizontally(N, G, J):- 	maplist(get_element_from_index(N), G, L), 
		             					sublist([J,J,J,J],L),!.
check_end_game_horizontally(N, G, J):-	N > 0,
										N1 is N - 1,
										check_end_game_horizontally(N1, G, J).

% check_end_game_horizontally/2 vérifie si 4 valeurs sont les mêmes horizontalement (Params : 1er = grille, J = joueur)
check_end_game_horizontally(G,J):- check_end_game_horizontally(6, G, J).				 

check_end_game_diagonally_second(_,D,J,0):- sublist([J,J,J,J],D).
check_end_game_diagonally_second(G,D,J,N):-	N > 0,
											maplist(get_element_from_index(N), G, L),
											get_element_from_index(N,L,E),
											N1 is N - 1,
											check_end_game_diagonally_second(G,[E|D],J,N1).

check_end_game_diagonally_second(G,J):- check_end_game_diagonally_second(G,[],J,6).

check_end_game_diagonally_first(_,D,J,0):-  sublist([J,J,J,J],D).
check_end_game_diagonally_first(G,D,J,N):-	N > 0,
											maplist(get_element_from_index(N), G, L),
											N2 is 7 - N,
											get_element_from_index(N2,L,E),
											N1 is N - 1,
											check_end_game_diagonally_first(G,[E|D],J,N1).

check_end_game_diagonally_first(G,J):- check_end_game_diagonally_first(G,[],J,6).


check_end_game_diagonally(_,_,X,J):- check_end_game_diagonally_first(X,J),!.
check_end_game_diagonally(_,_,X,J):- check_end_game_diagonally_second(X,J),!.
check_end_game_diagonally(G,N,X,J):-	N < 7,
										maplist(get_element_from_index(N), G, L),
										N1 is N + 1,
										check_end_game_diagonally(G,N1,[L|X],J).

% check_end_game_diagonally/2 vérifie si 4 valeurs sont les mêmes en diagonale (Params : G = grille, J = joueur)
check_end_game_diagonally(G,J):- check_end_game_diagonally(G,1,[],J).

% check_end_game/2 vérifie pour chaque joueur si il a gagné (Params : G = grille, J = joueur gagnant retourné)
check_end_game(G, J):- check_end_game_vertically(G,x), J=x.
check_end_game(G, J):- check_end_game_vertically(G,o), J=o.
check_end_game(G, J):- check_end_game_horizontally(G,x), J=x.
check_end_game(G, J):- check_end_game_horizontally(G,o), J=o.
check_end_game(G, J):- check_end_game_diagonally(G,x), J=x.
check_end_game(G, J):- check_end_game_diagonally(G,o), J=o.

% turn_x/1 vérifie si o a gagné sinon demande à x de jouer (Params : G = grille)
turn_x(G):- check_end_game(G,J), print_winner(J),!.
turn_x(G):- print_turn_x(),
			read(N), make_move(N,G, x, X, G),
			print_board(X),
			nl,
			turn_o(X).

% turn_o/1 vérifie si x a gagné sinon demande à o de jouer (Params : G = grille)
turn_o(G):- check_end_game(G,J), print_winner(J),!.
turn_o(G):- print_turn_o(),
			read(N), make_move(N,G, o, X, G),
			print_board(X),
			nl,
			turn_x(X).

% play affiche la grille de jeu et démarre un 1 contre 1, le joueur o commence
play:- print_board([[],[],[],[],[],[],[]]), nl, turn_o([[],[],[],[],[],[],[]]).

% winning_move/3 vérifie un coup lui permet de gagner la partie, si oui il retourne le coup en question (Params : C = coup gagnant, G = grille, J = joueur)
winning_move(C,G,J):- make_move_ai(1,G,J,N,G), check_end_game(N,J), C=1.
winning_move(C,G,J):- make_move_ai(2,G,J,N,G), check_end_game(N,J), C=2.
winning_move(C,G,J):- make_move_ai(3,G,J,N,G), check_end_game(N,J), C=3.
winning_move(C,G,J):- make_move_ai(4,G,J,N,G), check_end_game(N,J), C=4.
winning_move(C,G,J):- make_move_ai(5,G,J,N,G), check_end_game(N,J), C=5.
winning_move(C,G,J):- make_move_ai(6,G,J,N,G), check_end_game(N,J), C=6.
winning_move(C,G,J):- make_move_ai(7,G,J,N,G), check_end_game(N,J), C=7.

% losing_move/2 vérifie que le coup de l'ia ne va pas parmettre à l'adversaire de gagner (Params : 1er = colonne, G = grille)
losing_move(1,G):- make_move_ai(1,G,o,N,G), winning_move(_,N,x).
losing_move(2,G):- make_move_ai(2,G,o,N,G), winning_move(_,N,x).
losing_move(3,G):- make_move_ai(3,G,o,N,G), winning_move(_,N,x).
losing_move(4,G):- make_move_ai(4,G,o,N,G), winning_move(_,N,x).
losing_move(5,G):- make_move_ai(5,G,o,N,G), winning_move(_,N,x).
losing_move(6,G):- make_move_ai(6,G,o,N,G), winning_move(_,N,x).
losing_move(7,G):- make_move_ai(7,G,o,N,G), winning_move(_,N,x).


space_left(1, [L|_], E, L):- lenght(L,N2), N3 is 6-N2, E=N3.
space_left(N, [_|X], E, L):- N > 0,
							N1 is N-1,
							space_left(N1, X, E, L).

turn_ai(G):- check_end_game(G,J), print_winner(J),!.

% turn_ai/1 joue un coup gagnant (Params : G = grille)
turn_ai(G):-	winning_move(C,G,o), make_move_ai(C,G,o,X,G),
			   	print_ai_move(C),
			   	print_board(X),
			   	nl,
			   	player_turn(X).

% turn_ai/1 joue un coup qui empêche l'adversaire de gagner (Params : G = grille)
turn_ai(G):-   	winning_move(C,G,x), make_move_ai(C,G,o,X,G),
			   	print_ai_move(C),
			   	print_board(X),
			   	nl,
			   	player_turn(X).


% turn_ai/1 joue un coup le plus au centre qui n'est pas perdant en essayant de gagner varticalement (Params : G = grille)
turn_ai(G):- space_left(4,G,E,L), end_of_list(L,o), E > 3, not(losing_move(4,G)), turn_ai(4,G).
turn_ai(G):- space_left(3,G,E,L), end_of_list(L,o), E > 3, not(losing_move(3,G)), turn_ai(3,G).
turn_ai(G):- space_left(5,G,E,L), end_of_list(L,o), E > 3, not(losing_move(5,G)), turn_ai(5,G).
turn_ai(G):- space_left(2,G,E,L), end_of_list(L,o), E > 3, not(losing_move(2,G)), turn_ai(2,G).
turn_ai(G):- space_left(6,G,E,L), end_of_list(L,o), E > 3, not(losing_move(6,G)), turn_ai(6,G).
turn_ai(G):- space_left(1,G,E,L), end_of_list(L,o), E > 3, not(losing_move(1,G)), turn_ai(1,G).
turn_ai(G):- space_left(7,G,E,L), end_of_list(L,o), E > 3, not(losing_move(7,G)), turn_ai(7,G).

% turn_ai/1 joue un coup le plus au centre qui n'est pas perdant (Params : G = grille)
turn_ai(G):- turn_ai(4,G), not(losing_move(4,G)).
turn_ai(G):- turn_ai(3,G), not(losing_move(3,G)).
turn_ai(G):- turn_ai(5,G), not(losing_move(5,G)).
turn_ai(G):- turn_ai(2,G), not(losing_move(2,G)).
turn_ai(G):- turn_ai(6,G), not(losing_move(6,G)).
turn_ai(G):- turn_ai(1,G), not(losing_move(1,G)).
turn_ai(G):- turn_ai(7,G), not(losing_move(7,G)).

% turn_ai/1 joue un coup le plus au centre (Params : G = grille)
turn_ai(G):- turn_ai(4,G).
turn_ai(G):- turn_ai(3,G).
turn_ai(G):- turn_ai(5,G).
turn_ai(G):- turn_ai(2,G).
turn_ai(G):- turn_ai(6,G).
turn_ai(G):- turn_ai(1,G).
turn_ai(G):- turn_ai(7,G).
turn_ai(G):- turn_ai(0,G).

turn_ai(0, _):- print_no_move_available().

turn_ai(C, G):- make_move_ai(C,G,o,X,G),
				print_ai_move(C),
				print_board(X),
				nl,
				player_turn(X).
		

% player_turn/1 demande au joueur contre l'ia de jouer (Params : G = grille)
player_turn(G):- print_turn_x(),
				read(N), make_move_player(N,G, x, X, G),
				print_board(X),
				nl,
				turn_ai(X).

player_turn(G):- check_end_game(G,J), print_winner(J),!.
% play_ai démarre un 1 contre ia, l'ia commence
play_ai:- turn_ai([[],[],[],[],[],[],[]]).







% print_winner/1 affiche le joueur gagnant (Params : J = Joueur)
print_winner(J):-write('Le gagnant est '), write(J).

print_turn_x:- write('Au tour de x ->'), nl.
print_turn_o:- write('Au tour de o ->'), nl.

print_no_move_available:- write('Aucune possibilité de jeu n\'a été trouvée'), nl.

print_impossible_move:- write('Impossible de jouer ce coup'), nl.

print_ai_move(C):- write('L\'IA joue en '), write(C), nl, nl.

print_board(_,0).							   
print_board(G, N):-	N > 0,
					N1 is N-1,
					maplist(get_element_from_index(N), G, L),
					print_list(L),
					print_separator(),
					print_board(G, N1).

% print_board/1 affiche la grille de jeu (Params : G = grille)
print_board(G):- print_column_numbers(), print_board(G,6).

print_column_numbers():- write(' + 1 + 2 + 3 + 4 + 5 + 6 + 7 +'), nl.

print_separator():- write(' +---+---+---+---+---+---+---+'), nl.

print_list([]):- write(' |'), nl.
print_list([E|L]):-  write(' | '), 
						print_value(E),
						print_list(L).
print_value([]):- write(' '),!.
print_value(E):- write(E).
