class RoundsController < ApplicationController
  before_filter :load_game, only: [:index, :show, :vote]

  def index
    @rounds = @game.rounds
  end

  def show
    @round = @game.rounds.find(params[:id])
    if @round.finished?
      round_finished
    elsif @game.waiting_for_storyteller?
      if @game.current_storyteller != current_user
        waiting_for_storyteller
      else
        storyteller
      end
    elsif @game.waiting_for_players?
      if @game.player_submitted_picture?(current_user)
        waiting_for_players
      else
        waiting_for_your_picture
      end
    elsif @game.waiting_for_votes?
      if @game.current_round.player_voted?(current_user)
        waiting_for_votes
      else
        waiting_for_your_vote
      end
    end
  end

  def vote
    @round = @game.rounds.find(params[:round_id])
    unless @round.player_voted?(current_user)
      image = @round.submitted_pictures.find(params[:photo_id])
      image.increment!(:no_votes)
      @round.picture_for_user(current_user).update(has_voted: true)
      if @game.current_round.submitted_pictures.where(has_voted: false).count == 0
        ScoreCalculatorWorker.perform_async(@round.id)
        @game.prepare_round
      end
    end
    flash[:success] = 'Thanks for your vote!'
    redirect_to root_path(@game)
  end

  private

  def load_game
    @game = current_user.games.find(params[:game_id])
  end

  def waiting_for_storyteller
    @state = 'waiting_for_storyteller'
  end

  def storyteller
    @state = 'storyteller'
    word = RandomWord.word
    $redis.set("round-word-#{@round.id}", word)
    @flickr_images = flickr.photos.search(tags: word, extras: 'url_q').to_a.sample(4)
    @submitted_picture = @round.picture_for_user(current_user)
  end

  def waiting_for_your_picture
    @state = 'waiting_for_your_picture'
    word = $redis.get("round-word-#{@round.id}") || RandomWord.word
    @flickr_images = flickr.photos.search(tags: word, extras: 'url_q').to_a.sample(4)
  end

  def waiting_for_players
    @state = 'waiting_for_players'
  end

  def waiting_for_votes
    @state = 'waiting_for_votes'
  end

  def waiting_for_your_vote
    @state = 'waiting_for_your_vote'
    @submitted_pictures = @round.submitted_pictures.where.not(user: current_user).shuffle
  end

  def round_finished
    @state = 'round_finished'
    @final_picture = @round.submitted_pictures.where(final_picture: true).first
    @start_picture = @round.submitted_pictures.where(start_picture: true).first
  end
end
