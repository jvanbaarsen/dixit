class AddStateToParticipation < ActiveRecord::Migration
  def change
    add_column :participations, :state, :string, default: 'pending'
  end
end
