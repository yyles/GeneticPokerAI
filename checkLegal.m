% check whether the hand is legal
% For a legal hand, spit out 0
% For illegal hand, make the illegal hand legal by changing the type and
% suit of the repeated cards

function y = checkLegal(hand,cardStack)
  
  if length(unique(hand)) == length(hand) %If it's a legal hand, then remain the way it is
      y = hand;
  else
      % if it's not, find out the unique pattern of the illegal hand
      % The unique pattern must be shorter than the length of the hand if
      % it's a illegal hand
      uniList = unique(hand);
      % How many cards need to redraw after throwing away the repeated
      % card(s)
      numRedraw = length(hand) - length(uniList);  
      stackSml = cardStack;
      
      % Which repeated hand(s) should be thrown out
      for i = 1:length(uniList)
          indxOut(i) = find(stackSml == (uniList(i)));
      end
      
      stackSml(indxOut) = [];
      % Redraw cards to fill up the holes of the thrown-away cards
      y = [datasample(stackSml, numRedraw,'Replace', false)', uniList];
  end  
end
         
