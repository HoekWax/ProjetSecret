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
		

% player_turn/1 demande au joueur contre l'ia de jouer, il vérifie aussi si l'ia a gagné (Params : G = grille)
player_turn(G):- check_end_game(G,J), print_winner(J),!.
player_turn(G):- print_turn_x(),
				read(N), make_move_player(N,G, x, X, G),
				print_board(X),
				nl,
				turn_ai(X).