%Author: Jiali Ying
%Student ID: 1346717
%This file is related to Cribbage card game, aimes to:
%1. calculate the score of the cards in player's hand
%  five parts comtribute to the score:
%   - if there are numbers add up to 15
%   - pairs 
%   -runs 
%   -flushes
%   -if cards in hand contains the jack of the same suit as the start card.
%2. select the best hand card for the highest score

%Define all the rank values
rank_value(ace, 1).
rank_value(jack, 10).
rank_value(queen, 10).
rank_value(king, 10).
rank_value(Rank, Rank) :-
    integer(Rank),
    Rank >= 2,
    Rank =< 10.

%Define all the rank values
rank(ace, 1).
rank(jack, 11).
rank(queen, 12).
rank(king, 13).
rank(Rank, Rank) :-
    integer(Rank),
    Rank >= 2,
    Rank =< 10.

%Define all suits and rank
suit(clubs).
suit(diamonds).
suit(hearts).
suit(spades).
rank_define(ace).
rank_define(jack).
rank_define(queen).
rank_define(king).
rank_define(2).
rank_define(3).
rank_define(4).
rank_define(5).
rank_define(6).
rank_define(7).
rank_define(8).
rank_define(9).
rank_define(10).

generate_card(Rank, Suit, card(Rank, Suit)).

% Generate the entire standard deck of cards
deck(Deck) :-
    findall(card(Rank, Suit), (rank_define(Rank), suit(Suit)), Deck).

hand_value([card(RankA, SuitA), card(RankB, SuitB), card(RankC, SuitC), card(RankD, SuitD)], 
           card(RankS, SuitS), Value):-
    rank_value(RankA, Value1),
    rank_value(RankB, Value2),
    rank_value(RankC, Value3),
    rank_value(RankD, Value4),
    rank_value(RankS, Value5),
    rank(RankA, Rank1),
    rank(RankB, Rank2),
    rank(RankC, Rank3),
    rank(RankD, Rank4),
    rank(RankS, Rank5),
    msort([Value1, Value2, Value3, Value4, Value5], SortedValue),
    msort([Rank1, Rank2, Rank3, Rank4, Rank5], SortedRank),
    sum15(SortedValue, Sum15Value),
    pair(SortedRank, PairValue),
    run(SortedRank, RunValue),
    flushes([SuitA, SuitB, SuitC, SuitD], SuitS, FlushesValue),
    one_for_his_nob([card(RankA, SuitA), card(RankB, SuitB), card(RankC, SuitC), card(RankD, SuitD)], card(RankS, SuitS), NobValue),
    Value is PairValue*2 + Sum15Value*2 + RunValue + FlushesValue + NobValue.

%sum of combinations
sumof(List, Sum) :- sumof(List, 0, Sum).
sumof([], Sum, Sum).
sumof([H|T], Sum, Goal):-
    Sum1 is Sum + H,
    sumof(T, Sum1, Goal).

%find all the combinations
combs([H|T],[H|T2]) :-
    combs(T,T2).
combs([_|T],T2) :-
    combs(T,T2).
combs([],[]).

%sum score: find all combinations, check if sum is 15, put to Fifteens
sum15(List, Sum15Value):-
    findall(Sublist, (combs(List, Sublist), sumof(Sublist, 15)), Fifteens),
    length(Fifteens, Sum15Value).

%check equality
equal([X, X]).

%pair value
pair(List, PairValue) :-
    findall(Sublist, (combs(List, Sublist), length(Sublist, 2), equal(Sublist)), Pairs),
        (Pairs = [] -> PairValue = 0; length(Pairs, PairValue)).

%sum of targets in the list, elements > 2 and = targets(the largest number)
sum_list([], _, 0).
sum_list([H|T], Target, Sum) :-
    (H > 2, H = Target ->
        sum_list(T, Target, Sum1),
        Sum is H + Sum1
    ;
        sum_list(T, Target, Sum)
    ).

%check if combination is run
consecutive([]).
consecutive([_]).
consecutive([X, Y|Rest]) :-
    Y =:= X + 1,
    consecutive([Y|Rest]).

%find to largest value(Target)
largest([T], T).
largest([H|T], Target) :-
    largest(T, Target1),
    (H > Target1 ->
        Target = H
        ;
    Target = Target1
    ).
        

%run score: find all combinations, check if is continuous, 
%get its length(which is score), put it to RunValue, add up RunValue list.
run(SortedRank, RunValue) :-
    findall(Length, (combs(SortedRank, Sublist), consecutive(Sublist), 
                length(Sublist, RunLength), Length is RunLength), RunValues),
    largest(RunValues, Target),
    sum_list(RunValues, Target, RunValue).
  %  write('RunValues: '), write(RunValues), nl.

%check if suits are the same
same_suits([]).
same_suits([_]).
same_suits([Suit, Suit|Rest]) :-
    same_suits([Suit|Rest]).

%check if suits are the same as startsuit
same_start_suits([], _).
same_start_suits([Suit|Rest], StartSuit) :-
    Suit = StartSuit,
    same_start_suits(Rest, StartSuit).

%flushes value
flushes(Suit, Startsuit, FlushesValue) :-
    (same_suits(Suit) ->
        (same_start_suits(Suit, Startsuit) -> FlushesValue is 5
        ;
        FlushesValue is 4
        );
    FlushesValue is 0).

%one for his nob value: find Startcard suit
%check if there is (jack, StartcardSuit) in Hand
one_for_his_nob(Hand, StartCard, NobValue) :-
    (StartCard = card(_, StartSuit),
    member(card(jack, StartSuit), Hand)
    -> NobValue is 1
    ;
    NobValue is 0
    ).

%generate all combinations
hand_combination(Cards, Hand) :-
    hand_combination(Cards, 4, Hand).

hand_combination(_, 0, []).
hand_combination([H|T], N, [H|Combination]) :-
    N > 0,
    N1 is N - 1,
    hand_combination(T, N1, Combination).
hand_combination([_|T], N, Combination) :-
    N > 0,
    hand_combination(T, N, Combination).

%caluclate sum of a list
pure_sum([], 0).
pure_sum([H|T], Sum) :-
    pure_sum(T, Sum1),
    Sum is H + Sum1.

%find all values, put in a list, calculate the average
average_combination_value(Combination, Cards, AverageValue) :-
    deck(Deck),
    subtract(Deck, Cards, SubDeck),
    findall(Value,
            (member(Startcard, SubDeck),
             findall(HandValue, 
                     hand_value(Combination, Startcard, HandValue), ValueList),
             average_value(ValueList, Value)),
            AverageValues),
    length(AverageValues, Count),
    pure_sum(AverageValues, Sum),
    AverageValue is Sum / Count.

%calculate average value for each 4-card combination
average_value(ValueList, AverageValue) :-
    length(ValueList, Length),
    pure_sum(ValueList, Sum),
    AverageValue is Sum / Length.
    
%calculate the average value for each 4-cards hand with 46 possible Startcards
%choose the one that has the largest average value to be Hand
%use that as Hand to find Startcard that can have the largest value
select_hand(Cards, Hand, Cribcards) :-
    findall(Hand, hand_combination(Cards, Hand), HandList),
    findall(AverageValue-Combination,
            (member(Combination, HandList),
             average_combination_value(Combination, Cards, AverageValue)),
            AverageValueCombList),
    max_member(_-Combination, AverageValueCombList),
    msort(AverageValueCombList, SortedAverageValueCombList),
    last(SortedAverageValueCombList, _-Hand),
    subtract(Cards, Hand, Cribcards).
