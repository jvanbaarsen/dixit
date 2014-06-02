class InvitationWorker
  include Sidekiq::Worker

  def perform(game_id, user_ids)
    game = Game.find(game_id)
    users = User.where(id: user_ids)
    users.each do |user|
      AppMailer.game_invite(game, user).deliver
    end
  end
end
