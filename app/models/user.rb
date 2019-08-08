class User < ApplicationRecord
  has_many :participants
  
  def rank
    return "Grandmaster" if elo >= 2400.0
    return "Master" if elo >= 2200.0
    return "Expert" if elo >= 2000.0
    return "Class A" if elo >= 1800.0
    return "Class B" if elo >= 1600.0
    return "Class C" if elo >= 1400.0
    return "Class D" if elo >= 1200.0
    return "Class E" if elo >= 1000.0
    return "Class F" if elo >= 800.0
    return "Class G" if elo >= 600.0
    return "Class H" if elo >= 400.0
    return "Class I" if elo >= 200.0
    "Class J"
  end
end
