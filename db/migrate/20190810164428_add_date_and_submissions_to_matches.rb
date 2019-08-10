class AddDateAndSubmissionsToMatches < ActiveRecord::Migration[5.2]
  def change
    add_column :matches, :date, :date
    add_column :matches, :submissions, :string
  end
end
