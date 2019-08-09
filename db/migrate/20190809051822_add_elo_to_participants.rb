class AddEloToParticipants < ActiveRecord::Migration[5.2]
  def change
    add_column :participants, :elo, :float
  end
end
