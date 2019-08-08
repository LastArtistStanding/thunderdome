class CreateMatches < ActiveRecord::Migration[5.2]
  def change
    create_table :matches do |t|
      t.string :topic
      t.integer :duration
      t.string :description

      t.timestamps
    end
  end
end
