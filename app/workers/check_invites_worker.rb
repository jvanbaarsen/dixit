class CheckInvitesWorker
  include Sidekiq::Worker

  def perform(game_id)
    game = Game.find(game_id)
    if game.participations.where(state: 'pending').count == 0
      game.prepare_round
    end
  end
end
