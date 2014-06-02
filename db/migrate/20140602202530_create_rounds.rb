class CreateRounds < ActiveRecord::Migration
  def change
    create_table :rounds do |t|
      t.integer :game_id
      t.text :story_fragment

      t.timestamps
    end
    add_index :rounds, :game_id
  end
end
