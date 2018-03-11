%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Puissance 4 - Équipe 3
%
% Les questions à poser sont : ?- play. et play_ai.
% Entrez ensuite un numéro de colonne. Par exemple : 3.
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Prédicats utilitaires
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% add_to_end/3 ajoute une valeur à la fin d'une liste (Params : 1er = valeur, 2e = liste, 3e = liste retournée)
add_to_end(Element,List,NewList) :- append(List,[Element],NewList).

% end_of_list/2 vérifie que le dernier élément de List est égal à Element (Params : 1er = liste, 2e = élément)
end_of_list([], _).
end_of_list(List, Element):- last(List,Element).

% sublist/2 retourne une sous-liste de List (Params : 1er = sous-liste, 2e = liste)
sublist(SubList,List):- append(SubList,_,List).
sublist(SubList,[_|TrimmedList]):- sublist(SubList,TrimmedList).

% lenght/2 retourne la longueur de la liste List (Params : 1er = liste, 2e = longueur)
lenght([],0).
lenght([_|List],Lenght):-	lenght(List,NewLenght),
							Lenght is NewLenght+1.

% get_element_from_index/3 retourne l'élément d'une liste à partir d'une position donnée (Params : 1er = position, 2e = liste, 3e = élément)
get_element_from_index(Position, List, []):- lenght(List, Lenght), Lenght < Position.
get_element_from_index(Position, List, Element):- nth1(Position, List, Element).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Prédicats de vérification de fin de jeu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Prédicats d'affichage
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% print_winner/1 affiche le joueur gagnant (Params : 1er = joueur)
print_winner(Player):-write('Le gagnant est '), write(Player).

print_turn_x:- write('Au tour de x ->'), nl.
print_turn_o:- write('Au tour de o ->'), nl.

print_no_move_available:- write('Aucune possibilité de jeu n\'a été trouvée'), nl.

print_impossible_move:- write('Impossible de jouer ce coup'), nl.

print_ai_move(Position):- write('List\'IA joue en '), write(Position), nl, nl.

print_board(_,0).							   
print_board(Board, Position):-	Position > 0,
								NewPosition is Position-1,
								maplist(get_element_from_index(Position), Board, List),
								print_list(List),
								print_separator(),
								print_board(Board, NewPosition).

% print_board/1 affiche la grille de jeu (Params : 1er = plateau)
print_board(Board):- print_column_numbers(), print_board(Board,6).

print_column_numbers():- write(' + 1 + 2 + 3 + 4 + 5 + 6 + 7 +'), nl.

print_separator():- write(' +---+---+---+---+---+---+---+'), nl.

print_list([]):- write(' |'), nl.
print_list([Element|List]):-  	write(' | '), 
								print_value(Element),
								print_list(List).
print_value([]):- write(' '),!.
print_value(Element):- write(Element).

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Prédicats pour le mode 1 vs ia
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% make_move_player/5 est pour le mode contre l'ia et garde en mémoire le coup qui vient d'être joué par le joueur et affiche une erreur si nécessaire
% (Params : 1er = position, 2e = plateau, 3e = joueur, 4e = nouveau plateau, 5e = plateau de sauvegarde)
make_move_player(1, [List|_], x, _, SaveBoard):- lenght(List,Position), Position >= 6, print_impossible_move(), player_turn(SaveBoard).
make_move_player(1, [List|Board], Player, NewBoard, _):- lenght(List,Position), Position < 6, add_to_end(Player,List,NewList), NewBoard=[NewList|Board].
make_move_player(Position, [_|_], x, _, SaveBoard):- Position > 7, print_impossible_move(), player_turn(SaveBoard).	
make_move_player(Position, [FirstElemtBoard|BoardLeft], Player, [FirstElemtBoard|NewBoard], SaveBoard):- 	Position > 0,
																											NewPosition is Position - 1,
																											make_move_player(NewPosition, BoardLeft, Player, NewBoard, SaveBoard).

% make_move_ai/5 est pour le mode contre l'ia et garde en mémoire le coup qui vient d'être joué par l'ia et affiche une erreur si nécessaire
% (Params : Les mêmes que make_move_player/5)
make_move_ai(1, [List|Board], Player, NewBoard, _):- lenght(List,Position), Position < 6, add_to_end(Player,List,NewList), NewBoard=[NewList|Board].
make_move_ai(Position, [FirstElemtBoard|BoardLeft], Player, [FirstElemtBoard|NewBoard], SaveBoard):- 	Position > 0,
																										NewPosition is Position - 1,
																										make_move_ai(NewPosition, BoardLeft, Player, NewBoard, SaveBoard).

% winning_move/3 vérifie un coup lui permet de gagner la partie, si oui il retourne le coup en question (Params : 1er = coup gagnant, 2e = plateau, 3e = joueur)
winning_move(WinningMove,Board,Player):- make_move_ai(1,Board,Player,NewBoard,Board), check_end_game(NewBoard,Player), WinningMove=1.
winning_move(WinningMove,Board,Player):- make_move_ai(2,Board,Player,NewBoard,Board), check_end_game(NewBoard,Player), WinningMove=2.
winning_move(WinningMove,Board,Player):- make_move_ai(3,Board,Player,NewBoard,Board), check_end_game(NewBoard,Player), WinningMove=3.
winning_move(WinningMove,Board,Player):- make_move_ai(4,Board,Player,NewBoard,Board), check_end_game(NewBoard,Player), WinningMove=4.
winning_move(WinningMove,Board,Player):- make_move_ai(5,Board,Player,NewBoard,Board), check_end_game(NewBoard,Player), WinningMove=5.
winning_move(WinningMove,Board,Player):- make_move_ai(6,Board,Player,NewBoard,Board), check_end_game(NewBoard,Player), WinningMove=6.
winning_move(WinningMove,Board,Player):- make_move_ai(7,Board,Player,NewBoard,Board), check_end_game(NewBoard,Player), WinningMove=7.

% losing_move/2 vérifie que le coup de l'ia ne va pas parmettre à l'adversaire de gagner (Params : 1er = position, 2e = plateau)
losing_move(1,Board):- make_move_ai(1,Board,o,NewBoard,Board), winning_move(_,NewBoard,x).
losing_move(2,Board):- make_move_ai(2,Board,o,NewBoard,Board), winning_move(_,NewBoard,x).
losing_move(3,Board):- make_move_ai(3,Board,o,NewBoard,Board), winning_move(_,NewBoard,x).
losing_move(4,Board):- make_move_ai(4,Board,o,NewBoard,Board), winning_move(_,NewBoard,x).
losing_move(5,Board):- make_move_ai(5,Board,o,NewBoard,Board), winning_move(_,NewBoard,x).
losing_move(6,Board):- make_move_ai(6,Board,o,NewBoard,Board), winning_move(_,NewBoard,x).
losing_move(7,Board):- make_move_ai(7,Board,o,NewBoard,Board), winning_move(_,NewBoard,x).

space_left(1, [List|_], Space, List):- lenght(List,Position2), Position3 is 6-Position2, Space=Position3.
space_left(Position, [_|BoardLeft], Space, List):- 	Position > 0,
													NewPosition is Position-1,
													space_left(NewPosition, BoardLeft, Space, List).

turn_ai(Board):- check_end_game(Board,Player), print_winner(Player),!.

% turn_ai/1 joue un coup gagnant (Params : 1er = plateau)
turn_ai(Board):-	winning_move(WinningMove,Board,o), make_move_ai(WinningMove,Board,o,NewBoard,Board),
					print_ai_move(WinningMove),
					print_board(NewBoard),
					nl,
					player_turn(NewBoard).

% turn_ai/1 joue un coup qui empêche l'adversaire de gagner (Params : 1er = plateau)
turn_ai(Board):-   	winning_move(WinningMove,Board,x), make_move_ai(WinningMove,Board,o,NewBoard,Board),
					print_ai_move(WinningMove),
					print_board(NewBoard),
					nl,
					player_turn(NewBoard).

% turn_ai/1 joue un coup le plus au centre qui n'est pas perdant en essayant de gagner varticalement (Params : 1er = plateau)
turn_ai(Board):- space_left(4,Board,Space,List), end_of_list(List,o), Space > 3, not(losing_move(4,Board)), turn_ai(4,Board).
turn_ai(Board):- space_left(3,Board,Space,List), end_of_list(List,o), Space > 3, not(losing_move(3,Board)), turn_ai(3,Board).
turn_ai(Board):- space_left(5,Board,Space,List), end_of_list(List,o), Space > 3, not(losing_move(5,Board)), turn_ai(5,Board).
turn_ai(Board):- space_left(2,Board,Space,List), end_of_list(List,o), Space > 3, not(losing_move(2,Board)), turn_ai(2,Board).
turn_ai(Board):- space_left(6,Board,Space,List), end_of_list(List,o), Space > 3, not(losing_move(6,Board)), turn_ai(6,Board).
turn_ai(Board):- space_left(1,Board,Space,List), end_of_list(List,o), Space > 3, not(losing_move(1,Board)), turn_ai(1,Board).
turn_ai(Board):- space_left(7,Board,Space,List), end_of_list(List,o), Space > 3, not(losing_move(7,Board)), turn_ai(7,Board).

% turn_ai/1 joue un coup le plus au centre qui n'est pas perdant (Params : 1er = plateau)
turn_ai(Board):- turn_ai(4,Board), not(losing_move(4,Board)).
turn_ai(Board):- turn_ai(3,Board), not(losing_move(3,Board)).
turn_ai(Board):- turn_ai(5,Board), not(losing_move(5,Board)).
turn_ai(Board):- turn_ai(2,Board), not(losing_move(2,Board)).
turn_ai(Board):- turn_ai(6,Board), not(losing_move(6,Board)).
turn_ai(Board):- turn_ai(1,Board), not(losing_move(1,Board)).
turn_ai(Board):- turn_ai(7,Board), not(losing_move(7,Board)).

% turn_ai/1 joue un coup le plus au centre (Params : 1er = plateau)
turn_ai(Board):- turn_ai(4,Board).
turn_ai(Board):- turn_ai(3,Board).
turn_ai(Board):- turn_ai(5,Board).
turn_ai(Board):- turn_ai(2,Board).
turn_ai(Board):- turn_ai(6,Board).
turn_ai(Board):- turn_ai(1,Board).
turn_ai(Board):- turn_ai(7,Board).
turn_ai(Board):- turn_ai(0,Board).

turn_ai(0, _):- print_no_move_available().

turn_ai(WinningMove, Board):- 	make_move_ai(WinningMove,Board,o,NewBoard,Board),
								print_ai_move(WinningMove),
								print_board(NewBoard),
								nl,
								player_turn(NewBoard).
		

% player_turn/1 demande au joueur contre l'ia de jouer, il vérifie aussi si l'ia a gagné (Params : 1er = plateau)
player_turn(Board):- check_end_game(Board,Player), print_winner(Player),!.
player_turn(Board):- 	print_turn_x(),
						read(Position), make_move_player(Position,Board, x, NewBoard, Board),
						print_board(NewBoard),
						nl,
						turn_ai(NewBoard).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Prédicats de démarrage du jeu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% play affiche la grille de jeu et démarre un 1 contre 1, le joueur o commence
play:- print_board([[],[],[],[],[],[],[]]), nl, turn_o([[],[],[],[],[],[],[]]).

% play_ai démarre un 1 contre ia, l'ia commence
play_ai:- turn_ai([[],[],[],[],[],[],[]]).
