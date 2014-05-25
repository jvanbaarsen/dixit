class InvitationWorker
  include Sidekiq::Worker

  def perform(game, user_ids)
    users = User.where(id: user_ids)
    users.each do |user|
      AppMailer.game_invite(game, user).deliver
    end
  end
end
