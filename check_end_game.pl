% check_end_game_vertically/2 vérifie si 4 valeurs sont les mêmes verticalement (Params : 1er = Board, 2e = Player)
check_end_game_vertically([L|_],Player):- sublist([Player,Player,Player,Player], L),!.
check_end_game_vertically([_|Board],Player):- check_end_game_vertically(Board,Player).


check_end_game_horizontally(Index, Board, Player):- 	maplist(get_element_from_index(Index), Board, L), 
		             					sublist([Player,Player,Player,Player],L),!.
check_end_game_horizontally(Index, Board, Player):-	Index > 0,
										NewIndex is Index - 1,
										check_end_game_horizontally(NewIndex, Board, Player).

% check_end_game_horizontally/2 vérifie si 4 valeurs sont les mêmes horizontalement (Params : 1er = grille, 2e = Player)
check_end_game_horizontally(Board,Player):- check_end_game_horizontally(6, Board, Player).				 

check_end_game_diagonally_second(_,D,Player,0):- sublist([Player,Player,Player,Player],D).
check_end_game_diagonally_second(Board,D,Player,Index):-	Index > 0,
											maplist(get_element_from_index(Index), Board, L),
											get_element_from_index(Index,L,E),
											NewIndex is Index - 1,
											check_end_game_diagonally_second(Board,[E|D],Player,NewIndex).

check_end_game_diagonally_second(Board,Player):- check_end_game_diagonally_second(Board,[],Player,6).

check_end_game_diagonally_first(_,D,Player,0):-  sublist([Player,Player,Player,Player],D).
check_end_game_diagonally_first(Board,D,Player,Index):-	Index > 0,
											maplist(get_element_from_index(Index), Board, L),
											Index2 is 7 - Index,
											get_element_from_index(Index2,L,E),
											NewIndex is Index - 1,
											check_end_game_diagonally_first(Board,[E|D],Player,NewIndex).

check_end_game_diagonally_first(Board,Player):- check_end_game_diagonally_first(Board,[],Player,6).


check_end_game_diagonally(_,_,X,Player):- check_end_game_diagonally_first(X,Player),!.
check_end_game_diagonally(_,_,X,Player):- check_end_game_diagonally_second(X,Player),!.
check_end_game_diagonally(Board,Index,X,Player):-	Index < 7,
										maplist(get_element_from_index(Index), Board, L),
										NewIndex is Index + 1,
										check_end_game_diagonally(Board,NewIndex,[L|X],Player).

% check_end_game_diagonally/2 vérifie si 4 valeurs sont les mêmes en diagonale (Params : 1er = Board, 2e = Player)
check_end_game_diagonally(Board,Player):- check_end_game_diagonally(Board,1,[],Player).

% check_end_game/2 vérifie pour chaque Playeroueur si il a gagné (Params : 1er = Board, 2e = Player gagnant retourné)
check_end_game(Board, Player):- check_end_game_vertically(Board,x), Player=x.
check_end_game(Board, Player):- check_end_game_vertically(Board,o), Player=o.
check_end_game(Board, Player):- check_end_game_horizontally(Board,x), Player=x.
check_end_game(Board, Player):- check_end_game_horizontally(Board,o), Player=o.
check_end_game(Board, Player):- check_end_game_diagonally(Board,x), Player=x.
check_end_game(Board, Player):- check_end_game_diagonally(Board,o), Player=o.