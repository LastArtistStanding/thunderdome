class ChangeDurationToStringInMatches < ActiveRecord::Migration[5.2]
  def change
    change_column :matches, :duration, :string
  end
end
