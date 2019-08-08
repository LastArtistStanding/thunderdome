namespace :td do
  desc "Creates a match"
  task :run_match, [:users, :scores] => :environment do |task, args|
    if args[:users].blank? || args[:scores].blank?
      puts "Values are blank."
      next
    end
    
    user_list = []
    score_list = []
    
    args[:users].split('|').each do |user|
      user_list.push user
    end
    args[:scores].split('|').each do |score, index|
      score_list.push score.to_i
    end
    
    if user_list.length != score_list.length
      puts "Mismatched array lengths."
      next
    end
    
    if user_list.length < 2
      puts "Insufficient participants."
      next
    end
    
    map_users(user_list)
    update_rankings(user_list, score_list)
  end
  
  def map_users(user_list)
    user_list.each_with_index do |user, index|
      if User.find_by(name: user).nil?
        user_list[index] = User.create(name: user, elo: 1200.0, wins: 0, losses: 0, ties: 0)
      else
        user_list[index] = User.find_by(name: user)
      end
    end
  end
  
  def update_rankings(user_list, score_list)
    elo_deltas = score_list.map { 0.0 }
    win_deltas = score_list.map { 0 }
    loss_deltas = score_list.map { 0 }
    tie_deltas = score_list.map { 0 }
    
    user_list.each_with_index do |user, user_index|
      user_score = score_list[user_index]
      
      score_list.each_with_index do |score, score_index|
        next if score_index == user_index
        
        if user_score > score
          elo_deltas[user_index] += calc_elo_change(user_list[user_index].elo, user_list[score_index].elo, 1.0)
          win_deltas[user_index] += 1
        elsif user_score < score
          elo_deltas[user_index] += calc_elo_change(user_list[user_index].elo, user_list[score_index].elo, 0.0)
          loss_deltas[user_index] += 1
        else
          elo_deltas[user_index] += calc_elo_change(user_list[user_index].elo, user_list[score_index].elo, 0.5)
          tie_deltas[user_index] += 1
        end
        
      end
      
      elo_deltas[user_index] /= (score_list.count.to_f - 1.0)
      elo_deltas[user_index] *= Math.sqrt(score_list.count.to_f - 1.0)
    end
    
    latest_match = Match.create
    user_list.each_with_index do |user, index|
      user.elo += elo_deltas[index]
      user.wins += win_deltas[index]
      user.losses += loss_deltas[index]
      user.ties += tie_deltas[index]
      
      Participant.create(
        { user_id: user.id, 
          match_id: latest_match.id, 
          score: score_list[index], 
          elo_delta: elo_deltas[index], 
          wins: win_deltas[index],
          losses: loss_deltas[index],
          ties: tie_deltas[index]
        })
      
      puts "#{user.name} has won #{win_deltas[index]}, lost #{loss_deltas[index]} and tied #{tie_deltas[index]}. Elo Change: #{elo_deltas[index]}"
      
      user.save!
    end
  end
  
  def calc_elo_change(player_elo, opponent_elo, win)
    k = 40
    
    probability = 1.0 / ( 1.0 + ( 10.0 ** ( ( opponent_elo - player_elo ) / 400.0 ) ) )

    ( k * (win - probability) )
  end
end
