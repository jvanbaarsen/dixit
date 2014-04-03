class AddStateToGame < ActiveRecord::Migration
  def change
    add_column :games, :state, :string, default: "new"
  end
end
