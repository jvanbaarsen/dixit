class AddHasVotedToSubmittedPicture < ActiveRecord::Migration
  def change
    add_column :submitted_pictures, :has_voted, :boolean, default: false
  end
end
