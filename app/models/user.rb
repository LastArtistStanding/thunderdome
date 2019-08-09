class User < ApplicationRecord
  has_many :participants
  
  def display_rank
    rank.sub('G', ' (Gold)').sub('T', ' (Trim)')
  end
  
  def rank
    return "DragonG" if elo >= 2500.0
    return "Dragon" if elo >= 2400.0
    return "RuneG" if elo >= 2300.0
    return "RuneT" if elo >= 2200.0
    return "Rune" if elo >= 2100.0
    return "AdamantG" if elo >= 2000.0
    return "AdamantT" if elo >= 1900.0
    return "Adamant" if elo >= 1800.0
    return "MithrilG" if elo >= 1700.0
    return "MithrilT" if elo >= 1600.0
    return "Mithril" if elo >= 1500.0
    return "SteelG" if elo >= 1400.0
    return "SteelT" if elo >= 1300.0
    return "Steel" if elo >= 1200.0
    return "IronG" if elo >= 1100.0
    return "IronT" if elo >= 1000.0
    return "Iron" if elo >= 900.0
    return "BronzeG" if elo >= 800.0
    return "BronzeT" if elo >= 700.0
    return "Bronze" if elo >= 0.0
    return "ChefHat"
  end
end
