class Participation < ActiveRecord::Base
  belongs_to :game
  belongs_to :user

  enum state: [:pending, :accepted, :denied]

  def self.create_invitation(game, user)
    participation = self.new(game: game, user: user)
    participation.state = :pending
    participation.save!
  end

  def accept_invite
    self.accepted!
    CheckInvitesWorker.perform_async(game.id)
  end

  def deny_invite
    self.destroy!
    CheckInvitesWorker.perform_async(game.id)
  end
end
