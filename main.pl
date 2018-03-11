:- consult(utils).
:- consult(check_end_game).
:- consult(print).
:- consult(onevsone).
:- consult(onevsia).

% play affiche la grille de jeu et démarre un 1 contre 1, le joueur o commence
play:- print_board([[],[],[],[],[],[],[]]), nl, turn_o([[],[],[],[],[],[],[]]).

% play_ai démarre un 1 contre ia, l'ia commence
play_ai:- turn_ai([[],[],[],[],[],[],[]]).
