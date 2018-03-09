% add_to_end/3 ajoute une valeur à la fin d'une liste (Params : 1er = valeur, 2e = liste, 3e = liste retournée)
add_to_end(X,Y,Z) :- append(Y,[X],Z).

% end_of_list/2 vérifie que le dernier élément de L est égal à E (Params : L = liste, E = élément)
end_of_list([], _).
end_of_list(L, E):- last(L,E).

% sublist/2 retourne une sous-liste de L (Params : S = sous-liste, L = liste)
prefix(P,L):-append(P,_,L).
sublist(S,L):-prefix(S,L).
sublist(S,[_|T]):-sublist(S,T).

% lenght/2 retourne la longueur de la liste L (Params : L = liste, N = longueur)
lenght([],0).
lenght([_|L],N):- lenght(L,N1),
				  N is N1+1.

% get_element_from_index/3 retourne l'élément d'une liste à partir d'un index donné (Params : IDX = index, L = liste, E = élément)
get_element_from_index(IDX, L, []):- lenght(L, N1), N1 < IDX.
get_element_from_index(IDX, L, E):- nth1(IDX, L, E).