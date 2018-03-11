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