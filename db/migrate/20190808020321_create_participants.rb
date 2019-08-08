class CreateParticipants < ActiveRecord::Migration[5.2]
  def change
    create_table :participants do |t|
      t.references :user, foreign_key: true
      t.references :match, foreign_key: true
      t.integer :score
      t.string :submission
      t.float :elo_delta
      t.integer :wins
      t.integer :losses
      t.integer :ties

      t.timestamps
    end
  end
end
