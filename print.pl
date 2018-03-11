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
print_list([Element|List]):-  write(' | '), 
						print_value(Element),
						print_list(List).
print_value([]):- write(' '),!.
print_value(Element):- write(Element).