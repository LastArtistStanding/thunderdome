class AddNameToParticipants < ActiveRecord::Migration[5.2]
  def change
    add_column :participants, :name, :string
  end
end
