% make_move_player/5 est pour le mode contre l'ia et garde en mémoire le coup qui vient d'être joué par le joueur et affiche une erreur si nécessaire (Params : Les mêmes que make_move/5)
make_move_player(1, [List|_], x, _, SaveBoard):- lenght(List,Index), Index >= 6, print_impossible_move(), player_turn(SaveBoard).
make_move_player(1, [List|Board], Player, NewBoard, _):- lenght(List,Index), Index < 6, add_to_end(Player,List,NewList), NewBoard=[NewList|Board].
make_move_player(Index, [_|_], x, _, SaveBoard):- Index > 7, print_impossible_move(), player_turn(SaveBoard).	
make_move_player(Index, [FirstElemtBoard|BoardLeft], Player, [FirstElemtBoard|NewBoard], SaveBoard):- 	Index > 0,
																										NewIndex is Index - 1,
																										make_move_player(NewIndex, BoardLeft, Player, NewBoard, SaveBoard).

% make_move_ai/5 est pour le mode contre l'ia et garde en mémoire le coup qui vient d'être joué par l'ia et affiche une erreur si nécessaire (Params : Les mêmes que make_move/5)
make_move_ai(1, [List|Board], Player, NewBoard, _):- lenght(List,Index), Index < 6, add_to_end(Player,List,NewList), NewBoard=[NewList|Board].
make_move_ai(Index, [FirstElemtBoard|BoardLeft], Player, [FirstElemtBoard|NewBoard], SaveBoard):- 	Index > 0,
																									NewIndex is Index - 1,
																									make_move_ai(NewIndex, BoardLeft, Player, NewBoard, SaveBoard).

% winning_move/3 vérifie un coup lui permet de gagner la partie, si oui il retourne le coup en question (Params : WinningMove = coup gagnant, 2e = Board, 3e = Player)
winning_move(WinningMove,Board,Player):- make_move_ai(1,Board,Player,NewBoard,Board), check_end_game(NewBoard,Player), WinningMove=1.
winning_move(WinningMove,Board,Player):- make_move_ai(2,Board,Player,NewBoard,Board), check_end_game(NewBoard,Player), WinningMove=2.
winning_move(WinningMove,Board,Player):- make_move_ai(3,Board,Player,NewBoard,Board), check_end_game(NewBoard,Player), WinningMove=3.
winning_move(WinningMove,Board,Player):- make_move_ai(4,Board,Player,NewBoard,Board), check_end_game(NewBoard,Player), WinningMove=4.
winning_move(WinningMove,Board,Player):- make_move_ai(5,Board,Player,NewBoard,Board), check_end_game(NewBoard,Player), WinningMove=5.
winning_move(WinningMove,Board,Player):- make_move_ai(6,Board,Player,NewBoard,Board), check_end_game(NewBoard,Player), WinningMove=6.
winning_move(WinningMove,Board,Player):- make_move_ai(7,Board,Player,NewBoard,Board), check_end_game(NewBoard,Player), WinningMove=7.

% losing_move/2 vérifie que le coup de l'ia ne va pas parmettre à l'adversaire de gagner (Params : 1er = colonne, 2e = Board)
losing_move(1,Board):- make_move_ai(1,Board,o,NewBoard,Board), winning_move(_,NewBoard,x).
losing_move(2,Board):- make_move_ai(2,Board,o,NewBoard,Board), winning_move(_,NewBoard,x).
losing_move(3,Board):- make_move_ai(3,Board,o,NewBoard,Board), winning_move(_,NewBoard,x).
losing_move(4,Board):- make_move_ai(4,Board,o,NewBoard,Board), winning_move(_,NewBoard,x).
losing_move(5,Board):- make_move_ai(5,Board,o,NewBoard,Board), winning_move(_,NewBoard,x).
losing_move(6,Board):- make_move_ai(6,Board,o,NewBoard,Board), winning_move(_,NewBoard,x).
losing_move(7,Board):- make_move_ai(7,Board,o,NewBoard,Board), winning_move(_,NewBoard,x).

space_left(1, [List|_], Space, List):- lenght(List,Index2), Index3 is 6-Index2, Space=Index3.
space_left(Index, [_|X], Space, List):- Index > 0,
										NewIndex is Index-1,
										space_left(NewIndex, X, Space, List).

turn_ai(Board):- check_end_game(Board,Player), print_winner(Player),!.

% turn_ai/1 joue un coup gagnant (Params : 1er = Board)
turn_ai(Board):-	winning_move(WinningMove,Board,o), make_move_ai(WinningMove,Board,o,NewBoard,Board),
					print_ai_move(WinningMove),
					print_board(NewBoard),
					nl,
					player_turn(NewBoard).

% turn_ai/1 joue un coup qui empêche l'adversaire de gagner (Params : 1er = Board)
turn_ai(Board):-   	winning_move(WinningMove,Board,x), make_move_ai(WinningMove,Board,o,NewBoard,Board),
					print_ai_move(WinningMove),
					print_board(NewBoard),
					nl,
					player_turn(NewBoard).


% turn_ai/1 joue un coup le plus au centre qui n'est pas perdant en essayant de gagner varticalement (Params : 1er = Board)
turn_ai(Board):- space_left(4,Board,Space,List), end_of_list(List,o), Space > 3, not(losing_move(4,Board)), turn_ai(4,Board).
turn_ai(Board):- space_left(3,Board,Space,List), end_of_list(List,o), Space > 3, not(losing_move(3,Board)), turn_ai(3,Board).
turn_ai(Board):- space_left(5,Board,Space,List), end_of_list(List,o), Space > 3, not(losing_move(5,Board)), turn_ai(5,Board).
turn_ai(Board):- space_left(2,Board,Space,List), end_of_list(List,o), Space > 3, not(losing_move(2,Board)), turn_ai(2,Board).
turn_ai(Board):- space_left(6,Board,Space,List), end_of_list(List,o), Space > 3, not(losing_move(6,Board)), turn_ai(6,Board).
turn_ai(Board):- space_left(1,Board,Space,List), end_of_list(List,o), Space > 3, not(losing_move(1,Board)), turn_ai(1,Board).
turn_ai(Board):- space_left(7,Board,Space,List), end_of_list(List,o), Space > 3, not(losing_move(7,Board)), turn_ai(7,Board).

% turn_ai/1 joue un coup le plus au centre qui n'est pas perdant (Params : 1er = Board)
turn_ai(Board):- turn_ai(4,Board), not(losing_move(4,Board)).
turn_ai(Board):- turn_ai(3,Board), not(losing_move(3,Board)).
turn_ai(Board):- turn_ai(5,Board), not(losing_move(5,Board)).
turn_ai(Board):- turn_ai(2,Board), not(losing_move(2,Board)).
turn_ai(Board):- turn_ai(6,Board), not(losing_move(6,Board)).
turn_ai(Board):- turn_ai(1,Board), not(losing_move(1,Board)).
turn_ai(Board):- turn_ai(7,Board), not(losing_move(7,Board)).

% turn_ai/1 joue un coup le plus au centre (Params : 1er = Board)
turn_ai(Board):- turn_ai(4,Board).
turn_ai(Board):- turn_ai(3,Board).
turn_ai(Board):- turn_ai(5,Board).
turn_ai(Board):- turn_ai(2,Board).
turn_ai(Board):- turn_ai(6,Board).
turn_ai(Board):- turn_ai(1,Board).
turn_ai(Board):- turn_ai(7,Board).
turn_ai(Board):- turn_ai(0,Board).

turn_ai(0, _):- print_no_move_available().

turn_ai(WinningMove, Board):- make_move_ai(WinningMove,Board,o,NewBoard,Board),
				print_ai_move(WinningMove),
				print_board(NewBoard),
				nl,
				player_turn(NewBoard).
		

% player_turn/1 demande au joueur contre l'ia de jouer, il vérifie aussi si l'ia a gagné (Params : 1er = Board)
player_turn(Board):- check_end_game(Board,Player), print_winner(Player),!.
player_turn(Board):- print_turn_x(),
				read(Index), make_move_player(Index,Board, x, NewBoard, Board),
				print_board(NewBoard),
				nl,
				turn_ai(NewBoard).