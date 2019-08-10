namespace :td do
  desc "Dumps database and recalculates."
  task :recalculate => :environment do
    Participant.destroy_all
    Match.destroy_all
    User.destroy_all
    
    ActiveRecord::Base.connection.reset_pk_sequence!(Participant.table_name)
    ActiveRecord::Base.connection.reset_pk_sequence!(Match.table_name)
    ActiveRecord::Base.connection.reset_pk_sequence!(User.table_name)
    
    matches = load_match_yaml
    matches.each do |battle|
      addMatch(battle[:participants], battle[:scores], battle[:details])
    end
  end
  
  task :update => :environment do
    matches = load_match_yaml
    matches.each_with_index do |battle, index|
      next if Match.find_by_id(index + 1)
      addMatch(battle[:participants], battle[:scores], battle[:details])
    end
  end
  
  def load_match_yaml
    matchData = YAML.load_file('db/data/match_data.yaml')
    matches = []
    
    matchData.each do |currentMatch, details|
      battle_details = {topic: details["topic"], duration: details["duration"], description: details["description"], date: details["date"]}
      hash = {participants: details["participants"], scores: details["scores"], details: battle_details}
      matches.push hash
    end
    
    return matches
  end
  
  def addMatch(users, scores, details)
    if users.blank? || scores.blank?
      puts "Values are blank."
      return
    end
    
    user_list = []
    score_list = []
    
    users.split('|').each do |user|
      user_list.push user
    end
    scores.split('|').each do |score, index|
      score_list.push score.to_i
    end
    
    if user_list.length != score_list.length
      puts "Mismatched array lengths."
      return
    end
    
    if user_list.length < 2
      puts "Insufficient participants."
      return
    end
    
    map_users(user_list)
    update_data(user_list, score_list, details)
  end
  
  def map_users(user_list)
    user_list.each_with_index do |user, index|
      if User.find_by(name: user).nil?
        user_list[index] = User.create(name: user, elo: 1200.0, wins: 0, losses: 0, ties: 0, multi_wins: 0, multi_losses: 0, multi_ties: 0)
      else
        user_list[index] = User.find_by(name: user)
      end
    end
  end
  
  def update_data(user_list, score_list, details)
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
    
    latest_match = Match.create(topic: details[:topic], duration: details[:duration], description: details[:description], date: details[:date])
    latest_match.submissions = "https://las-thunderdome.s3.us-east-2.amazonaws.com/submissions/#{latest_match.id}.png"
    
    puts "Match #{latest_match.id} (#{details[:topic] || 'Unknown Topic'} - #{details[:duration] || '30 min'}) recorded!"
    user_list.each_with_index do |user, index|
      puts "#{user.name} (#{user.elo.floor}) has won #{win_deltas[index]}, lost #{loss_deltas[index]} and tied #{tie_deltas[index]}. Elo Change: #{elo_deltas[index].round}"
      
      Participant.create(
        { user_id: user.id,
          name: user.name,
          elo: user.elo,
          match_id: latest_match.id,
          score: score_list[index], 
          elo_delta: elo_deltas[index], 
          wins: win_deltas[index],
          losses: loss_deltas[index],
          ties: tie_deltas[index]
        })
      
      user.elo += elo_deltas[index]
      if user_list.count == 2
        user.wins += win_deltas[index]
        user.losses += loss_deltas[index]
        user.ties += tie_deltas[index]
      else
        user.multi_wins += win_deltas[index]
        user.multi_losses += loss_deltas[index]
        user.multi_ties += tie_deltas[index]
      end
      
      user.save!
    end
    puts "-----"
    puts ""
  end
  
  def calc_elo_change(player_elo, opponent_elo, win)
    k = 80
    
    probability = 1.0 / ( 1.0 + ( 10.0 ** ( ( opponent_elo - player_elo ) / 400.0 ) ) )

    ( k * (win - probability) )
  end
end
