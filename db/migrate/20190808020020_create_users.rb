class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.float :elo
      t.integer :wins
      t.integer :losses
      t.integer :ties

      t.timestamps
    end
  end
end
