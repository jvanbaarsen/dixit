class Game < ActiveRecord::Base
  has_many :participations
  has_many :users, through: :participations
  has_many :rounds

  enum state: [:inviting, :invites_send, :waiting_for_storyteller, :waiting_for_players, :waiting_for_votes, :finished]

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
    if inviting?
      user_ids = self.participations.where(state: Participation.states[:pending]).pluck(:user_id)
      InvitationWorker.perform_async(self.id, user_ids)
      self.invites_send!
    end
  end

  def prepare_round
    round = Round.create(game: self)
    round.prepare(self.users)
    self.waiting_for_storyteller!
  end

  def current_storyteller
    if self.rounds.any?
      current_round.storyteller
    else
      User.new
    end
  end

  def current_round
    self.rounds.last
  end

  def self.running
    where.not(state: states[:finished])
  end
end
