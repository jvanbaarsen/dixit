class Game < ActiveRecord::Base
  has_many :participations
  has_many :users, through: :participations

  def self.running
    where.not(state: 'finished')
  end
end
