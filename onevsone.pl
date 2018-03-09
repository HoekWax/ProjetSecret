% make_move/5 est pour le mode 1 contre 1 et garde en mémoire le coup qui vient d'être joué et affiche une erreur si nécessaire (Params : 1er = colonne, 2e = grille, 3e = joueur, 4e = nouvelle grille, 5e = grille de sauvegarde)	
make_move(1, [L|_], x, _, I):- lenght(L,N), N >= 6, print_impossible_move(), turn_x(I).
make_move(1, [L|_], o, _, I):- lenght(L,N), N >= 6, print_impossible_move(), turn_o(I).
make_move(1, [L|G], J, F, _):- lenght(L,N), N < 6, add_to_end(J,L,M), F=[M|G].
make_move(N, [_|_], x, _, I):- N > 7, print_impossible_move(), turn_x(I).
make_move(N, [_|_], o, _, I):- N > 7, print_impossible_move(), turn_o(I).
make_move(N, [T|X], J, [T|G], I):- 	N > 0,
									N1 is N - 1,
									make_move(N1, X, J, G, I).

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