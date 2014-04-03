class CreateParticipations < ActiveRecord::Migration
  def change
    create_table :participations do |t|
      t.integer :user_id
      t.integer :game_id

      t.timestamps
    end

    add_index :participations, [:user_id, :game_id]
  end
end
