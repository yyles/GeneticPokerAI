% To maintain equal number of population in each generation, each cross
% over will generate two children.

function [children1, children2] = crossOver(parent1, parent2, cardStack)

pickRnd = 1:4; % can pick 1~4 cards from one hand to do cross over

% randomly pick a number from 1 ~4
num2PickH1 = datasample(pickRnd, 1,'Replace', false); % pick how many from hand1
num2PickH2 = 5 - num2PickH1; % pick how many from hand2


% draw cards from hand1 & hand2
child1 = datasample(parent1, num2PickH1,'Replace', false);
child2 = datasample(parent2, num2PickH2, 'Replace', false);

% put both hand1 and hand1 portions together to make a new hand
children1 = [child1,child2];

% the cards that I didn't draw from hand1 and hand2 are put together to
% make another new hand
child3 = parent1(ismember(parent1,child1) == 0);
child4 = parent2(ismember(parent2, child2) == 0);

children2 = [child3, child4];

% check if both children are legal hands
children1 = checkLegal(children1, cardStack);
children2 = checkLegal(children2, cardStack);


end


%%% mark this function; make sure two parents will produce two children