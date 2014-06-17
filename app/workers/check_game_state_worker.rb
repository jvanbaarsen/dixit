class CheckGameStateWorker
  include Sidekiq::Worker

  def perform(game_id)
    game = Game.find(game_id)
    if game.waiting_for_players?
      if game.current_round.submitted_pictures.where(flickr_id: nil).count == 0
        game.waiting_for_votes!
      end
    end
  end
end
