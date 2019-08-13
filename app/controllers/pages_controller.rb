class PagesController < ApplicationController
  def index
    @users = User.all.order(elo: :desc).limit(30)
    @matches = Match.all.order(id: :desc).limit(30)
    
    @ranks = [0.0, 600.0, 750.0, 900.0, 1050.0, 1200.0, 1350.0, 1500.0, 1650.0,
              1800.0, 1950.0, 2100.0, 2250.0, 2400.0, 2550.0, 2700.0, 2850.0,
              3000.0, 3500.0, 4000.0]
              
    @ranks.each_with_index do |rank, index|
      user = User.new(elo: rank)
      hash = {display_name: user.display_rank, rank_name: user.rank, elo: rank}
      @ranks[index] = hash
    end
  end
end