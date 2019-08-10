class MatchesController < ApplicationController
  def index
    @matches = Match.all.order(id: :desc)
  end
  
  def show
    @match = Match.find(params[:id])
    @participants = @match.participants
  end
end
