class AddMultidomeRecordsToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :multi_wins, :integer
    add_column :users, :multi_losses, :integer
    add_column :users, :multi_ties, :integer
  end
end
