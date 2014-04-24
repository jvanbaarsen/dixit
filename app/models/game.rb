class Game < ActiveRecord::Base
  has_many :participations
  has_many :users, through: :participations

  state_machine initial: :new do
    event :invites_send do
      transition new: :invites_send
    end

    event :waiting_for_storyteller do
      transition [:invites_send, :waiting_for_votes] => :waiting_for_storyteller
    end

    event :waiting_for_players do
      transition waiting_for_storyteller: :waiting_for_players
    end

    event :waiting_for_votes do
      transition waiting_for_players: :waiting_for_votes
    end

    event :finish do
      transition waiting_for_votes: :finished
    end
  end

  def invite_player(user)
    unless users.include?(user)
      users << user
    end
  end

  def self.running
    where.not(state: 'finished')
  end
end
