class CreateSubmittedPictures < ActiveRecord::Migration
  def change
    create_table :submitted_pictures do |t|
      t.integer :user_id
      t.integer :round_id
      t.integer :no_votes
      t.boolean :start_picture, default: false
      t.boolean :final_picture, default: false
      t.string :flick_id

      t.timestamps
    end
  end
end
