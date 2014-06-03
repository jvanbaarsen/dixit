class AddRoundNumberToRound < ActiveRecord::Migration
  def change
    add_column :rounds, :round_number, :integer, default: 1
  end
end
