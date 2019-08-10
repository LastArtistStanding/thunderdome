class UsersController < ApplicationController
  def index
    @users = User.all.order(elo: :desc)
    @match_count = @users.map { |u| Participant.where(name: u.name).count }
    @last_match = @users.map { |u| Participant.where(name: u.name).last.match }
    @opponents = @last_match.each_with_index.map do |m, i|
      if m.participants.count > 2
        "#{m.participants.count}-way Multidome - #{@last_match[i].topic}"
      else
        victory = m.participants.second.wins == 1
        opponent = m.participants.first.name
        if opponent == @users[i].name
          victory = m.participants.first.wins == 1
          opponent = m.participants.second.name 
        end
        
        "#{victory ? "Win" : "Loss"} vs #{opponent} - #{@last_match[i].topic} "
      end
    end
  end
  
  def show
    @user = User.find(params[:id])
    @participations = Participant.where(name: @user.name).order(id: :desc)
    
    @all_matches = []
    @participations.each { |p| @all_matches.push p.match }
    @head_to_heads = {}
    @all_matches.each do |m|
      score = m.participants.find_by(name: @user.name).score
      
      m.participants.each do |p|
        next if p.name == @user.name
        
        if @head_to_heads[p.name].nil?
          @head_to_heads[p.name] = {wins: 0, ties: 0, losses: 0, multi_wins: 0, multi_ties: 0, multi_losses: 0, total_wins: 0, total_ties: 0, total_losses: 0}
        end
        
        if m.participants.count > 2
          @head_to_heads[p.name][:multi_wins] += 1 if score > p.score
          @head_to_heads[p.name][:multi_ties] += 1 if score == p.score
          @head_to_heads[p.name][:multi_losses] += 1 if score < p.score
        else
          @head_to_heads[p.name][:wins] += 1 if score > p.score
          @head_to_heads[p.name][:ties] += 1 if score == p.score
          @head_to_heads[p.name][:losses] += 1 if score < p.score
        end
        @head_to_heads[p.name][:total_wins] += 1 if score > p.score
        @head_to_heads[p.name][:total_ties] += 1 if score == p.score
        @head_to_heads[p.name][:total_losses] += 1 if score < p.score
      end
    end
    
    @matches = []
    @participations.each do |p|
      @matches.push p.match
    end
    @opponents = @matches.each_with_index.map do |m, i|
      if m.participants.count > 2
        "#{m.participants.count}-dome"
      else
        opponent = m.participants.first.name
        if opponent == @user.name
          opponent = m.participants.second.name 
        end
        
        opponent
      end
    end
    @results = @participations.each_with_index.map do |p, i| 
      if @matches[i].participants.count == 2
        if p.wins.positive?
          "Win"
        elsif p.losses.positive?
          "Loss"
        else 
          "Tie"
        end
      else
        "W:#{p.wins} | T:#{p.ties} | L:#{p.losses}"
      end
    end
  end
end
