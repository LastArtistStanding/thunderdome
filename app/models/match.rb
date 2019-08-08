class Match < ApplicationRecord
  has_many :participants
  
  def get_winners
    winners = ""
    
    participants.each do |participant|
      if participant.losses == 0
        if winners.blank?
          winners = participant.user.name
        else
          winners += ", #{participant.user.name}"
        end
      end
    end
  end
end
