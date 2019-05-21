% consult('http://courses.softlab.ntua.gr/pl1/2014a/Exercises/exerc14-3.pdf').

anagrams(S1, S2, Moves) :-
    string_to_list(S1, L1),
    string_to_list(S2, L2),
    is_permutation_of_fast(L1, L2),
    reverse(L1, RL1),
    reverse(L2, RL2),
    once(solve(RL1, RL2, Moves)).

is_permutation_of_fast(L1, L2) :- msort(L1, Sorted), msort(L2, Sorted).

is_permutation_of([], []).
is_permutation_of([H|T], L2) :-
    select(H, L2, NewL2),
    is_permutation_of(T, NewL2).

select(H, [H], []).
select(H, [X|T], [X|T2]) :- H = X -> T = T2 ; select(H, T, T2).

solve(L1, L2, Moves) :- length(Moves, _), reach((L1, [], []), Moves, L2).

reach(([], [], Goal), [], Goal).
reach(State, [Move|RestMoves], Goal) :-
    next(State, NewState, Move),
    allowed_plan(Move, RestMoves),
    reach(NewState, RestMoves, Goal).

next((L1,      [C], L2),      ([C|L1],  [],   L2),      '01').
next((L1,      [C], L2),      (L1,      [],   [C|L2]),  '02').
next(([H1|T1], [],  L2),      (T1,      [H1], L2),      '10').
next(([H1|T1], L0,  L2),      (T1,      L0,   [H1|L2]), '12').
next((L1,      [],  [H2|T2]), (L1,      [H2], T2),      '20').
next((L1,      L0,  [H2|T2]), ([H2|L1], L0,   T2),      '21').

allowed_plan(_, []).
allowed_plan(M, [H | _]) :- allowed_after(M, H). 

allowed_after('01', NextMove) :- member(NextMove, ['20', '21']).
allowed_after('02', NextMove) :- member(NextMove, ['10', '12']).
allowed_after('10', NextMove) :- member(NextMove, ['12', '21']).
allowed_after('12', NextMove) :- member(NextMove, ['01', '02', '10', '12']).
allowed_after('20', NextMove) :- member(NextMove, ['12', '21']).
allowed_after('21', NextMove) :- member(NextMove, ['01', '02', '20', '21']).
