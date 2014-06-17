class AddScoreToParticipations < ActiveRecord::Migration
  def change
    add_column :participations, :score, :integer, default: 0
  end
end
