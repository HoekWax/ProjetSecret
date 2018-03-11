%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Prédicats pour le mode 1 vs 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% make_move/5 est pour le mode 1 contre 1 et garde en mémoire le coup qui vient d'être joué et affiche une erreur si nécessaire
% (Params : 1er = position, 2e = plateau, 3e = joueur, 4e = nouveau plateau, 5e = plateau de sauvegarde)	
make_move(1, [List|_], x, _, SaveBoard):- lenght(List,Position), Position >= 6, print_impossible_move(), turn_x(SaveBoard).
make_move(1, [List|_], o, _, SaveBoard):- lenght(List,Position), Position >= 6, print_impossible_move(), turn_o(SaveBoard).
make_move(1, [List|BoardLeft], Player, NewBoard, _):- lenght(List,Position), Position < 6, add_to_end(Player,List,NewList), NewBoard=[NewList|BoardLeft].
make_move(Position, [_|_], x, _, SaveBoard):- Position > 7, print_impossible_move(), turn_x(SaveBoard).
make_move(Position, [_|_], o, _, SaveBoard):- Position > 7, print_impossible_move(), turn_o(SaveBoard).
make_move(Position, [FirstElemtBoard|BoardLeft], Player, [FirstElemtBoard|NewBoard], SaveBoard):- 	Position > 0,
																									NewPosition is Position - 1,
																									make_move(NewPosition, BoardLeft, Player, NewBoard, SaveBoard).

% turn_x/1 vérifie si o a gagné sinon demande à x de jouer (Params : 1er = plateau)
turn_x(Board):- check_end_game(Board,Player), print_winner(Player),!.
turn_x(Board):- print_turn_x(),
				read(Position), make_move(Position,Board, x, NewBoard, Board),
				print_board(NewBoard),
				nl,
				turn_o(NewBoard).

% turn_o/1 vérifie si x a gagné sinon demande à o de jouer (Params : 1er = plateau)
turn_o(Board):- check_end_game(Board,Player), print_winner(Player),!.
turn_o(Board):- print_turn_o(),
				read(Position), make_move(Position,Board, o, NewBoard, Board),
				print_board(NewBoard),
				nl,
				turn_x(NewBoard).