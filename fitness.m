% suit: 1 = hearts, 2 = spades, 3 = diamonds, 4 = clubs
% Points for each type of hand
% Royal flush = 130
% Four of a kind = 105
% Straight flush = 55
% Full House = 50
% Flush = 35
% Straight = 25
% Three of a kind = 20
% Two pair = 15
% One pair = 10
% regular hand = 5


function  score = fitness(hand)

handSorted = sort(hand); % sort the hand 

suit = zeros(1,5); % place holder for suit of each hand

number = zeros(1,5); % place holder for number 

for i = 1:5

% For each card, convert number to string. So I can split the suit and
% number into different lists.
digit = num2str(handSorted(i)) ; 

suit(i) = str2num(digit(length(digit)));

number(i) = handSorted(i) - 0.1 * suit(i);

end

% Each hand is re-organized into a 5 by 2 matrix (one column for all the
% numbers, one column for all the suits
cardReorg = [suit' number'];

% Since all five cards in a flush hand would have the same suit, I
% calculated the different between adjacent elements in suits. If it
% returns four 0s, then it's a flush
checkFlush = length(find(diff(suit) == 0));

%Same idea for straight, I calcuated the difference bewteen adjacent
%elements in numbers. If it returns 1s, then it could be a straight
checkStraight = length(find(diff(number) == 1));


score = 5; % regular hand has a fitness of 5

if checkFlush == 4   % if it's a flush
    score = score + 30;  %flush = 35 points
    if number == [1 10 11 12 13] % check if it's a royal flush
        score = score + 95; % royal flush = 130 points
    end
end

if checkStraight == 4    % if it's a straight
    score = score + 20;  % straight = 25 points
                         % flush + straight = 35 + 20 = 55 points
end

% check x of a kind
% hist(number) gives me the counts of each number in one hand
counts = hist(number);
counts(counts == 0) = [];
counts = sort(counts);

comp = length(counts);

% four of a kind has 4 cards who have the same rank and 1 other card
fourKind = [1 4];
fullHouse = [2 3];
threeKind = [ 1 1 3];
twoPair = [1 2 2];
onePair = [1 1 1 2];

if comp == 2
    if counts == fourKind
        score = score + 100;  % four of a kind  = 105
    end
    
    if counts == fullHouse
        score = score + 45;   % full house = 50
    end
end

if comp == 3
    
    if counts == threeKind  % three of a kind = 20
        score = score + 15;
    end
    
    if counts == twoPair     % two pair = 15
        score = score + 10;
    end   
end

if comp == 4
    if counts == onePair  % one pair = 10
        score = score + 5;
    end
end

end
