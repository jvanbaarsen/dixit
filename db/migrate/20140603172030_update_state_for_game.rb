class UpdateStateForGame < ActiveRecord::Migration
  def change
    remove_column :games, :state
    add_column :games, :state, :integer, default: 0
  end
end
