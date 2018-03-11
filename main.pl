%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Puissance 4 - Équipe 3
%
% Les questions à poser sont : ?- play. et play_ai.
% Entrez ensuite un numéro de colonne. Par exemple : 3.
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- consult(utils).
:- consult(check_end_game).
:- consult(print).
:- consult(onevsone).
:- consult(onevsia).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Prédicats de démarrage du jeu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% play affiche la grille de jeu et démarre un 1 contre 1, le joueur o commence
play:- print_board([[],[],[],[],[],[],[]]), nl, turn_o([[],[],[],[],[],[],[]]).

% play_ai démarre un 1 contre ia, l'ia commence
play_ai:- turn_ai([[],[],[],[],[],[],[]]).
