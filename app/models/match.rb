class Match < ApplicationRecord
  has_many :participants
  
  def winners
    winner_list = []
    
    participants.each do |participant|
      if participant.losses == 0
        winner_list.push participant
      end
    end
    
    winner_list
  end
  
  def losers
    loser_list = []
    
    participants.each do |participant|
      if participant.wins == 0
        loser_list.push participant
      end
    end
    
    loser_list
  end
  
  def flavor_text
    return duel_text if participants.count == 2
    
    multidome_text
  end
  
  def duel_text
    return duel_tie if participants.first.ties == 1
    
    duel_non_tie_text
  end
  
  def multidome_text
    names = participants.map { |p| p.user.name }
    scores = participants.map { |p| p.score }
    winner_index = scores.each_with_index.max[1]
    winner_name = names[winner_index]
    winner_score = scores[winner_index]
    average_score = (scores.sum - winner_score).to_f / (scores.count - 1).to_f
    next_highest = scores.each_with_index.max(2)[1][0]
    
    return multidome_tie if winner_score == average_score
    return multidome_winner_tie(winners) if winner_score == next_highest
    return multidome_sweep(winner_name) if average_score == 0
    return multidome_destroy(winner_name) if winner_score > (scores.sum - winner_score)
    return multidome_close(winner_name) if winner_score * 0.7 < average_score
    
    multidome_standard(winner_name)
  end
  
  def multidome_tie
    num = participants.count
    
    ["Unbelievably, this #{num}-multidome resulted in a complete stalemate.",
     "These #{num} artists proved to be evenly matched against one another."].sample
  end
  
  def multidome_winner_tie(winners)
    num = participants.count
    
    winner_string = ""
    winners.each_with_index do |w, i|
      winner_name = w.user.name
      if winner_string.blank?
        winner_string = winner_name
      elsif i == winners.count - 1
        winner_string += " and #{winner_name}"
      elsif i == winners.count - 2
        winner_string += " #{winner_name}"
      else
        winner_string += " #{winner_name},"
      end
    end
    
    ["In this, #{num}-multidome, #{winner_string} have risen above the competition.",
     "#{winner_string} are the cream of the crop of these #{num} artists.",
     "As #{num} artists conclude their battle, only #{winner_string} remain."].sample
  end
  
  def multidome_sweep(winner)
    num = participants.count
    
    ["#{winner} completely destroyed their #{num - 1} opponents.",
     "In a #{num}-way battle, #{winner} emerged completely untouched."].sample
  end
  
  def multidome_destroy(winner)
    num = participants.count
    
    ["Among these #{num} artists, #{winner} stands in a league of their own.",
     "#{pos(winner)} work outclassed the other #{num - 1}.",
     "#{winner} emerged the indisputable victor in a #{num}-way battle."].sample
  end
  
  def multidome_close(winner)
    num = participants.count
    
    ["In a tight #{num}-way battle, #{winner} achieved a close victory.",
     "#{pos(winner)} work stood out amongst the #{num - 1} other solid works.",
     "Though #{winner} won, the other #{num - 1} artists put up a good fight."].sample
  end
  
  def multidome_standard(winner)
    num = participants.count
    
    ["As the dust settles, #{winner} emerged the best of the #{num}.",
     "#{winner} created the best work of the #{num} participants.",
     "Of the #{num} works submitted, the audience favored #{pos(winner)} artwork."].sample
  end
  
  def duel_tie
    first = participants.first.user.name
    second = participants.second.user.name
    
    ["After a spirited duel, #{first} and #{second} seem to be evenly matched.",
     "#{first} and #{second} have proven themselves equivalent in strength.",
     "A tense battle between #{first} and #{second} resulted in a tie.",
     "#{first} and #{second} have tied in a nailbitingly close match.",
     "Neither #{first} nor #{second} emerge victorious in their duel."].sample
  end
  
  def duel_non_tie_text
    names = participants.map { |p| p.user.name }
    scores = participants.map { |p| p.score }
    winner_index = scores.each_with_index.max[1]
    loser_index = scores.each_with_index.min[1]
    
    winner_name = names[winner_index]
    winner_score = scores[winner_index]
    loser_name = names[loser_index]
    loser_score = scores[loser_index]
    
    return forfeit_duel_text(winner_name, loser_name) if loser_score == -1
    return close_duel_text(winner_name, loser_name) if (loser_score == winner_score - 1) || (winner_score * 0.85 <= loser_score)
    return sweep_duel_text(winner_name, loser_name) if loser_score == 0
    return defeat_duel_text(winner_name, loser_name) if loser_score * 2 <= winner_score
    standard_duel_text(winner_name, loser_name)
  end
  
  def forfeit_duel_text(winner, loser)
    ["Intimidated by #{pos(winner)} work, #{loser} resigned.",
     "#{loser} forfeited the match. #{winner} wins by default.",
     "#{loser}, unsatisfied with their work, conceded to #{winner}."].sample
  end
  
  def close_duel_text(winner, loser)
    ["Despite #{pos(loser)} best efforts, #{winner} won.",
     "#{winner} barely clinches the win over #{loser}.",
     "In a very close bout, #{winner} defeated #{loser}.",
     "#{pos(winner)} efforts were just enough to beat #{loser}.",
     "#{winner} won, but the defeated #{loser} made a valiant effort."].sample
  end
  
  def defeat_duel_text(winner, loser)
    ["#{loser} lost soundly to their opponent, #{winner}.",
     "#{winner} thoroughly defeated #{loser}.",
     "#{winner} managed to score more than twice #{pos(loser)} votes.",
     "#{pos(loser)} work compared very unfavorably to #{pos(winner)}.",
     "In a brutal battle, #{loser} lost badly to #{winner}."].sample
  end
  
  def sweep_duel_text(winner, loser)
    ["#{loser} failed to even score against #{winner}",
     "The merciless #{winner} obliterated #{loser}.",
     "#{winner} achieved total victory over #{loser}."].sample
  end
  
  def standard_duel_text(winner, loser)
    ["#{loser} lost to #{winner}.",
     "#{winner} vanquished #{loser}.",
     "#{winner} has beaten #{loser}.",
     "#{loser} was defeated by #{winner}.",
     "#{winner} claimed victory over #{loser}.",
     "People preferred #{pos(winner)} work to #{pos(loser)}.",
     "#{pos(winner)} was more appealing than #{pos(loser)}."].sample
  end
  
  def pos(name)
    name + ('s' == name[-1,1] ? "'" : "'s")
  end
end
