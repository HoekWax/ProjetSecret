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