class Game < ActiveRecord::Base
  has_many :participations
  has_many :users, through: :participations

  state_machine initial: :new do
    event :invites_send do
      transition new: :invites_send
      transition invites_send: :invites_send
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

    event :finished do
      transition waiting_for_votes: :finished
    end
  end

  def invite_player(user)
    unless users.include?(user)
      Participation.create_invitation(self, user)
    end
  end

  def authors
    self.users.collect(&:name)
  end

  def formatted_state
    I18n.t "game_status.#{self.state}"
  end

  def send_invitations
    if new?
      user_ids = self.participations.where(state: 'pending').pluck(:user_id)
      InvitationWorker.perform_async(self, user_ids)
      self.invites_send!
    end
  end

  def self.running
    where.not(state: 'finished')
  end
end
