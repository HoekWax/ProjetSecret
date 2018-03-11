% check_end_game_vertically/2 vérifie si 4 valeurs sont les mêmes verticalement (Params : 1er = plateau, 2e = joueur)
check_end_game_vertically([L|_],Player):- sublist([Player,Player,Player,Player], L),!.
check_end_game_vertically([_|Board],Player):- check_end_game_vertically(Board,Player).


check_end_game_horizontally(Position, Board, Player):- 	maplist(get_element_from_index(Position), Board, L), 
		             									sublist([Player,Player,Player,Player],L),!.
check_end_game_horizontally(Position, Board, Player):-	Position > 0,
														NewPosition is Position - 1,
														check_end_game_horizontally(NewPosition, Board, Player).

% check_end_game_horizontally/2 vérifie si 4 valeurs sont les mêmes horizontalement (Params : 1er = plateau, 2e = joueur)
check_end_game_horizontally(Board,Player):- check_end_game_horizontally(6, Board, Player).				 

check_end_game_diagonally_second(_,D,Player,0):- sublist([Player,Player,Player,Player],D).
check_end_game_diagonally_second(Board,D,Player,Position):-	Position > 0,
															maplist(get_element_from_index(Position), Board, L),
															get_element_from_index(Position,L,E),
															NewPosition is Position - 1,
															check_end_game_diagonally_second(Board,[E|D],Player,NewPosition).

check_end_game_diagonally_second(Board,Player):- check_end_game_diagonally_second(Board,[],Player,6).

check_end_game_diagonally_first(_,D,Player,0):-  sublist([Player,Player,Player,Player],D).
check_end_game_diagonally_first(Board,D,Player,Position):-	Position > 0,
															maplist(get_element_from_index(Position), Board, L),
															Position2 is 7 - Position,
															get_element_from_index(Position2,L,E),
															NewPosition is Position - 1,
															check_end_game_diagonally_first(Board,[E|D],Player,NewPosition).

check_end_game_diagonally_first(Board,Player):- check_end_game_diagonally_first(Board,[],Player,6).


check_end_game_diagonally(_,_,X,Player):- check_end_game_diagonally_first(X,Player),!.
check_end_game_diagonally(_,_,X,Player):- check_end_game_diagonally_second(X,Player),!.
check_end_game_diagonally(Board,Position,X,Player):-	Position < 7,
														maplist(get_element_from_index(Position), Board, L),
														NewPosition is Position + 1,
														check_end_game_diagonally(Board,NewPosition,[L|X],Player).

% check_end_game_diagonally/2 vérifie si 4 valeurs sont les mêmes en diagonale (Params : 1er = plateau, 2e = joueur)
check_end_game_diagonally(Board,Player):- check_end_game_diagonally(Board,1,[],Player).

% check_end_game/2 vérifie pour chaque Playeroueur si il a gagné (Params : 1er = plateau, 2e = joueur gagnant retourné)
check_end_game(Board, Player):- check_end_game_vertically(Board,x), Player=x.
check_end_game(Board, Player):- check_end_game_vertically(Board,o), Player=o.
check_end_game(Board, Player):- check_end_game_horizontally(Board,x), Player=x.
check_end_game(Board, Player):- check_end_game_horizontally(Board,o), Player=o.
check_end_game(Board, Player):- check_end_game_diagonally(Board,x), Player=x.
check_end_game(Board, Player):- check_end_game_diagonally(Board,o), Player=o.