class Participant < ApplicationRecord
  belongs_to :user
  belongs_to :match
  
  def display_rank
    rank.sub('G', ' (Gold)').sub('T', ' (Trim)')
  end
  
  def rank
    return "DragonG" if elo >= 4000.0
    return "Dragon" if elo >= 3500.0
    return "RuneG" if elo >= 3000.0
    return "RuneT" if elo >= 2850.0
    return "Rune" if elo >= 2700.0
    return "AdamantG" if elo >= 2550.0
    return "AdamantT" if elo >= 2400.0
    return "Adamant" if elo >= 2250.0
    return "MithrilG" if elo >= 2100.0
    return "MithrilT" if elo >= 1950.0
    return "Mithril" if elo >= 1800.0
    return "SteelG" if elo >= 1650.0
    return "SteelT" if elo >= 1500.0
    return "Steel" if elo >= 1350.0
    return "IronG" if elo >= 1200.0
    return "IronT" if elo >= 1050.0
    return "Iron" if elo >= 900.0
    return "BronzeG" if elo >= 750.0
    return "BronzeT" if elo >= 600.0
    return "Bronze" if elo >= 0.0
    return "ChefHat"
  end
  
  def row_style
    return "table-warning" if wins.zero? && losses.zero?
    return "table-danger" if wins.zero?
    return "table-success" if losses.zero?
    
    "table-warning"
  end
end
