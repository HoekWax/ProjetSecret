

% affichage de grille https://github.com/piclemx/ift-2003/blob/master/tp2/nouvelleGrille.pl

% lancerIA. et jouer. à renommer en 1v1 et 1vIA par exemple. pour le 1v1, afficher la grille vide au début
% Quand l'ia gagne, la game continue, A FIXER

% Quand on arrive à impossible de jouer ce coupc ou ce genre de chose ça nique tout pour l'affichage du
% ctrl f et tt remplacer
% OK - Changer tous les texte (celui ci à gagné, c'est à lui de jouer etc)
% Voir les fonctions heurstiques (pourquoi faire un move et pas un autre pour win par exemple, voir la valeur des coups)
% OK - Mettre la page de garde de marketing sur le drive
% Diviser en plusieurs fichier (un main, un setup etats etc, fonctions utiles (ajouter fin de liste), affichage de grille, evaluation de la fin du jeu).
% OK - Revoir l'affichage de la grille et mettre les numero de lignes, refaire tous les commentaires
% Refaire tous les commentaires
% OK -n renommer les fonctions en anglais (play_game_o etc)
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
make_move(1, [L|G], x, _, I):- lenght(L,N), N >= 6, print_impossible_move(), turn_x(I).
make_move(1, [L|G], o, _, I):- lenght(L,N), N >= 6, print_impossible_move(), turn_o(I).
make_move(1, [L|G], J, F, I):- lenght(L,N), N < 6, add_to_end(J,L,M), F=[M|G].
make_move(N, [L|G], x, _, I):- N > 7, print_impossible_move(), turn_x(I).
make_move(N, [L|G], o, _, I):- N > 7, print_impossible_move(), turn_o(I).
make_move(N, [T|X], J, [T|G], I):- 	N > 0,
									N1 is N-1,
									make_move(N1, X, J, G, I).
					
make_move_player(1, [L|G], x, _, I):- lenght(L,N), N >= 6, print_impossible_move(), player_turn(I).
make_move_player(1, [L|G], J, F, I):- lenght(L,N), N < 6, add_to_end(J,L,M), F=[M|G].
make_move_player(N, [L|G], x, _, I):- N > 7, print_impossible_move(), player_turn(I).	
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
check_end_game_horizontally(N, G, J):- 	maplist(get_element_from_index(N), G, L), 
										sublist([J,J,J,J],L),!.
check_end_game_horizontally(N, G, J):-	N > 0,
										N1 is N-1,
										check_end_game_horizontally(N1, G, J).

check_end_game_horizontally(G,J):- check_end_game_horizontally(6, G, J).				 

check_end_game_diagonally_2(G,D,J,0):- sublist([J,J,J,J],D).
check_end_game_diagonally_2(G,D,J,N):-	N > 0,
										maplist(get_element_from_index(N), G, L),
										get_element_from_index(N,L,E),
										N1 is N-1,
										check_end_game_diagonally_2(G,[E|D],J,N1).

check_end_game_diagonally_2(G,J):- check_end_game_diagonally_2(G,[],J,6).

check_end_game_diagonally_1(G,D,J,0):- sublist([J,J,J,J],D).
check_end_game_diagonally_1(G,D,J,N):-	N > 0,
										maplist(get_element_from_index(N), G, L),
										N2 is 7-N,
										get_element_from_index(N2,L,E),
										N1 is N-1,
										check_end_game_diagonally_1(G,[E|D],J,N1).

check_end_game_diagonally_1(G,J):- check_end_game_diagonally_1(G,[],J,6).


check_end_game_diagonally(G,N,X,J):- check_end_game_diagonally_1(X,J),!.
check_end_game_diagonally(G,N,X,J):- check_end_game_diagonally_2(X,J),!.
check_end_game_diagonally(G,N,X,J):-	N < 7,
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


/* Param�tres : G grille*/
turn_x(G):-check_end_game(G,J), print_winner(J),!.
turn_o(G):-check_end_game(G,J), print_winner(J),!.
turn_x(G):- print_turn_x(),
			read(N), make_move(N,G, x, X, G),
			print_board(X),
			nl,
			turn_o(X).
turn_o(G):- print_turn_o(),
			read(N), make_move(N,G, o, X, G),
			print_board(X),
			nl,
			turn_x(X).

% Lancement du jeu : grille de d�part de 6*7 (vide). C'est le joueur 'o' qui commence, suivi par x, jusqu'� ce que l'un des deux gagne [ou GRILLE PLEINE]
play:- print_board([[],[],[],[],[],[],[]]), nl, turn_o([[],[],[],[],[],[],[]]).

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

player_turn(G):-check_end_game(G,J), print_winner(J),!.
turn_ai(G):-check_end_game(G,J), print_winner(J),!.


%Si un coup permet de gagner il faut le jouer.
turn_ai(G):-	winning_move(C,G,o), make_move_ai(C,G,o,X,G),
			   	print_ai_move(C),
			   	print_board(X),
			   	nl,
			   	player_turn(X).

%Si un coup permet a l'adversaire de gagner on se défend(coup défensif).
turn_ai(G):-   	winning_move(C,G,x), make_move_ai(C,G,o,X,G),
			   	print_ai_move(C),
			   	print_board(X),
			   	nl,
			   	player_turn(X).

turn_ai(0, G):- print_no_move_available().


turn_ai(C, G):- make_move_ai(C,G,o,X,G),
				print_ai_move(C),
			    print_board(X),
			    nl,
			    player_turn(X).

space_left(1, [L|G], E, L):- lenght(L,N2), N3 is 6-N2, E=N3.
space_left(N, [T|X], E, L):- N > 0,
								N1 is N-1,
								space_left(N1, X, E, L).
									
%Si on a pas de coup immédiat on fait un coup au centre ou au plus près possible pour une victoire possible en verticale.
turn_ai(G):- space_left(4,G,E,L), end_of_list(L,o), E > 3, not(losing_move(4,G)), turn_ai(4,G).
turn_ai(G):- space_left(5,G,E,L), end_of_list(L,o), E > 3, not(losing_move(5,G)), turn_ai(5,G).
turn_ai(G):- space_left(3,G,E,L), end_of_list(L,o), E > 3, not(losing_move(3,G)), turn_ai(3,G).
turn_ai(G):- space_left(6,G,E,L), end_of_list(L,o), E > 3, not(losing_move(6,G)), turn_ai(6,G).
turn_ai(G):- space_left(2,G,E,L), end_of_list(L,o), E > 3, not(losing_move(2,G)), turn_ai(2,G).
turn_ai(G):- space_left(7,G,E,L), end_of_list(L,o), E > 3, not(losing_move(7,G)), turn_ai(7,G).
turn_ai(G):- space_left(1,G,E,L), end_of_list(L,o), E > 3, not(losing_move(1,G)), turn_ai(1,G).

%Sinon jouer au plus près du centre quand même.
turn_ai(G):- turn_ai(4,G),not(losing_move(4,G)).
turn_ai(G):- turn_ai(5,G),not(losing_move(5,G)).
turn_ai(G):- turn_ai(3,G),not(losing_move(3,G)).
turn_ai(G):- turn_ai(6,G),not(losing_move(6,G)).
turn_ai(G):- turn_ai(2,G),not(losing_move(2,G)).
turn_ai(G):- turn_ai(7,G),not(losing_move(7,G)).
turn_ai(G):- turn_ai(1,G),not(losing_move(1,G)).

%Déblocage de situation
turn_ai(G):- turn_ai(4,G).
turn_ai(G):- turn_ai(5,G).
turn_ai(G):- turn_ai(3,G).
turn_ai(G):- turn_ai(6,G).
turn_ai(G):- turn_ai(2,G).
turn_ai(G):- turn_ai(7,G).
turn_ai(G):- turn_ai(1,G).
turn_ai(G):- turn_ai(0,G).

player_turn(G):- print_turn_x(),
				read(N), make_move_player(N,G, x, X, G),
				print_board(X),
				nl,
				turn_ai(X).

play_ai:- turn_ai([[],[],[],[],[],[],[]]).



% Affichage du gagnant
/* Param�tres : J joueur */
print_winner(J):-write('Le gagnant est '), write(J).

print_turn_x:- write('Au tour de x ->'), nl.
print_turn_o:- write('Au tour de o ->'), nl.

print_no_move_available:- write('Aucune possibilité de jeu n'a été trouvée), nl.

print_impossible_move:- write('Impossible de jouer ce coup'), nl.

print_ai_move(C):- write('L\'IA joue en '), write(C), nl, nl.

print_board(_,0).							   
print_board(G, N):-	 N > 0,
						N1 is N-1,
						maplist(get_element_from_index(N), G, L),
						print_list(L),
						print_separator(),
						print_board(G, N1).

print_board(G):- print_column_numbers(), print_board(G,6).

print_column_numbers():- write(' + 1 + 2 + 3 + 4 + 5 + 6 + 7 +'), nl.

print_separator():- write(' +---+---+---+---+---+---+---+'), nl.

print_list([]):- write(' |'), nl.
print_list([E|L]):-  write(' | '), 
						print_value(E),
						print_list(L).
print_value([]):- write(' '),!.
print_value(E):- write(E).
