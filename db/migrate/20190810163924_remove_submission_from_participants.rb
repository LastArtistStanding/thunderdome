class RemoveSubmissionFromParticipants < ActiveRecord::Migration[5.2]
  def change
    remove_column :participants, :submission, :string
  end
end
