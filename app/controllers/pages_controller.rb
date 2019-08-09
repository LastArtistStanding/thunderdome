class PagesController < ApplicationController
  def index
    @users = User.all.order(elo: :desc)
    @matches = Match.all.order(id: :desc)
    
    @ranks = [0.0, 700.0, 800.0, 900.0, 1000.0, 1100.0, 1200.0, 1300.0, 1400.0,
              1500.0, 1600.0, 1700.0, 1800.0, 1900.0, 2000.0, 2100.0, 2200.0,
              2300.0, 2400.0, 2500.0]
              
    @ranks.each_with_index do |rank, index|
      user = User.new(elo: rank)
      hash = {display_name: user.display_rank, rank_name: user.rank, elo: rank}
      @ranks[index] = hash
    end
  end
end