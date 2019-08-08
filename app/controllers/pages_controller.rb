class PagesController < ApplicationController
  def index
    @users = User.all.order(elo: :desc)
    @matches = Match.all
  end
end