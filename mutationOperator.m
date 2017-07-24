% mutatate a hand by changing one or two of the cards to different cards

function y = mutationOperator(hand, cardStack)

pickNum = randperm(2);

numOfMut = pickNum(1); % number of cards that need to be mutated.

handIndx = 1:5;

% pick which card(s) in a hand will be mutated

mutIndx = datasample(handIndx, numOfMut,'Replace', false);

hand(mutIndx) = []; % delete the muted card and deal new cards

% This operation says the mutated card could have a change of number or
% suit or both
newDeal = datasample(cardStack, numOfMut, 'Replace', false);


hand = [ hand, newDeal'];

y = checkLegal(hand, cardStack);

end





