clear all
clc
% Citation: Stochastic universal sampling method is from wiki url: https://en.wikipedia.org/wiki/Stochastic_universal_sampling
% Make up a population of 100 random card hands; a card is represented by
% a double digit number with one decimal point as the suit


% first make a stack of all the possile cards
cardStackMat = zeros(13, 4);

for i = 1:13
    for j = 1:4
     cardStackMat(i,j) =  i + j * 0.1;
    end
end

% reshape the cardStack matrix to make it an array so it is convenient for
% drawing cards
cardStack = reshape(cardStackMat, [52,1]);


% place holder for 100 random card hands
initPopulation = zeros(100,5);


    
for i = 1:100
initPopulation(i,:) = datasample(cardStack, 5, 'Replace', false);
end

% Initial population;
population = initPopulation;

% place holder for fitness score
fitScore = zeros(100,1);

% Loop through 250 generations
for gen = 1:250
    
% Calculate the fitness for each hand in each generation
for t = 1:length(population)
    hand = population(t,:);
    fitScore(t) = fitness(hand);
end

%For each run, print out the generation number, average fitness, and the
%hand who has the max fitness
gen 
avgFitness = mean(fitScore)
maxHand = population(find(max(fitScore)),:)


% throw away hands who already have high scores (full house and higher)

highIndx = find(fitScore >= 50);
fitScore(highIndx) = [];
population(highIndx,:) = [];
totalFitness = sum(fitScore);

% 80% cross over, 10% mutation, 10% elitism
% use stochastic universal sampling
% choose cross over
numCrossover = round(length(fitScore) * 0.8);

FN_cross = round(sum(fitScore)/2); % even spaced interval
pickStarter_cross = 1:FN_cross; % array to draw the starter

% pick two hands to do cross over each time; loop it through pairNum times
pairNum = round(numCrossover * 0.5);
numCrossover = pairNum * 2;

% In order for hands who have higher fitness scores are more likely to be
% selected, a pointer list is created based on the fitness score of each
% hand. For example, hand1 has a fitness of 10, then the indx number of
% hand1 (1) appears 10 times consecutively in the pointer array.
v = 1:length(fitScore);
indxPointer = repelem(v, fitScore);
indxPointer = indxPointer';


for q = 1:pairNum
    
starter_cross = datasample(pickStarter_cross, 1,'Replace', false);   % randomly pick a start pointer from the indx array

for j = 1:2
% pick two hands each time, from the starter, then another one should be
% the starter + interval
pointers(q,j) = starter_cross + FN_cross * (j-1);

end

end

% This part is used to check when a pointer is out of bound
prt1 = pointers(:,1);
prt2 = pointers(:,2);
indx_outbound1 = find(prt1 > totalFitness);
indx_outbound2 = find(prt2 > totalFitness);
if ~isempty(indx_outbound1)
for n = 1:length(indx_outbound1)
    prt1(indx_outbound1(n)) = datasample(pickStarter_cross, 1,'Replace', false);
end
end

if ~isempty(indx_outbound2)
for n = 1:length(indx_outbound2)
    prt2(indx_outbound2(n)) = datasample(pickStarter_cross, 1,'Replace', false);
end
end

% choose the parent hands to do the cross over
parent1Indx = indxPointer(prt1);
parent2Indx = indxPointer(prt2);

parentG1 = population(parent1Indx,:);
parentG2 = population(parent2Indx,:);

for p = 1:length(pointers)
    parent1 = parentG1(p,:);
    parent2 = parentG2(p,:);
    
    [x,y] = crossOver(parent1, parent2, cardStack);
    child1(p,:) = x;
    child2(p,:) = y;
end

% the next generation children which are generated through cross overs
crossCard = vertcat(child1, child2);


% mutation
% how many hands should do mutation
numMutation = round(length(fitScore) * 0.1);

%stochastic selection

FN_mut = round(sum(fitScore)/numMutation); % even spaced interval
pickStarter_mut = 1:FN_mut;

starter_mut = datasample(pickStarter_mut, 1,'Replace', false);

for w = 1:(numMutation)
prt_mut = starter_mut + FN_mut * (w-1);
pointers_mut(w) = prt_mut;

end

% check if pointer is out of bound
prt_mut = pointers_mut;

indx_outbound_mut = find(prt_mut > totalFitness);

if ~isempty(indx_outbound_mut)
for n = 1:length(indx_outbound_mut)
    prt_mut(indx_outbound_mut(n)) = datasample(pickStarter_cross, 1,'Replace', false);
end
end


mutIndx = indxPointer(prt_mut);
hands2mut = population(mutIndx,:);

for o = 1:length(hands2mut)
    hand = hands2mut(o,:);
    mutCard(o,:) = mutationOperator(hand, cardStack);
end

% repeat itself
numElimism = length(fitScore) - numCrossover - numMutation;

FN_rep = round(sum(fitScore)/numElimism); % even spaced interval
pickStarter_rep = 1:FN_rep;

starter_rep = datasample(pickStarter_rep, 1,'Replace', false);

for w = 1:(numElimism)
pointers_rep(w) = starter_rep + FN_rep * (w-1);

while pointers_rep > totalFitness
    pointers_rep(w) = datasample(pickStarter_rep, 1,'Replace', false);
end

end

prt_rep = pointers_rep;

indx_outbound_rep = find(prt_rep > totalFitness);

if ~isempty(indx_outbound_rep)
for n = 1:length(indx_outbound_rep)
    prt_rep(indx_outbound_rep(n)) = datasample(pickStarter_cross, 1,'Replace', false);
end
end

repIndx = indxPointer(prt_rep);
hands2rep = population(repIndx,:);

population = vertcat(crossCard, mutCard, hands2rep);

fitnessGen(:,gen) = avgFitness; % record average fitness
maxhandGen(gen,:) = maxHand; % record hand with max fitness


end

fitnessGen = fitnessGen';
generationNum = 1:250;

generationNum = generationNum';

% how to write data into .txt file
% from url http://www.mathworks.com/matlabcentral/answers/47448-save-data-to-txt-file
header1 = 'Generation_Number';
header2 = 'avg_fitness';
header3 = 'hand_maxFitness';

data = [generationNum fitnessGen maxhandGen];

t = table(data);
writetable(t, 'myFile.txt');












