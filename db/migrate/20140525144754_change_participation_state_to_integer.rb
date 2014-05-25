class ChangeParticipationStateToInteger < ActiveRecord::Migration
  def up
    remove_column :participations, :state
    add_column :participations, :state, :integer, default: 0
  end

  def down
    remove_column :participations, :state
    add_column :participations, :state, :string, default: 'pending'
  end
end
