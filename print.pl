% print_winner/1 affiche le joueur gagnant (Params : J = Joueur)
print_winner(J):-write('Le gagnant est '), write(J).

print_turn_x:- write('Au tour de x ->'), nl.
print_turn_o:- write('Au tour de o ->'), nl.

print_no_move_available:- write('Aucune possibilité de jeu n\'a été trouvée'), nl.

print_impossible_move:- write('Impossible de jouer ce coup'), nl.

print_ai_move(C):- write('L\'IA joue en '), write(C), nl, nl.

print_board(_,0).							   
print_board(G, N):-	N > 0,
					N1 is N-1,
					maplist(get_element_from_index(N), G, L),
					print_list(L),
					print_separator(),
					print_board(G, N1).

% print_board/1 affiche la grille de jeu (Params : G = grille)
print_board(G):- print_column_numbers(), print_board(G,6).

print_column_numbers():- write(' + 1 + 2 + 3 + 4 + 5 + 6 + 7 +'), nl.

print_separator():- write(' +---+---+---+---+---+---+---+'), nl.

print_list([]):- write(' |'), nl.
print_list([E|L]):-  write(' | '), 
						print_value(E),
						print_list(L).
print_value([]):- write(' '),!.
print_value(E):- write(E).