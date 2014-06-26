class ScoreCalculatorWorker
  include Sidekiq::Worker

  def perform(round_id)
    round = Round.find(round_id)
    game = round.game

    best_picture = round.submitted_pictures.order(:no_votes).first
    best_picture.update(final_picture: true)

    round.submitted_pictures.each do |picture|
      score = 0
      if picture.start_picture?
        score = 8 * picture.no_votes
      else
        score = 5 * picture.no_votes
      end
      Participation.where(game: game_id, user: picture.user).first.update(score: score)
    end
  end
end
