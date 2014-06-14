class RoundsController < ApplicationController
  before_filter :load_game, only: [:index, :show]

  def index
    @rounds = @game.rounds
  end

  def show
    @round = @game.rounds.find(params[:id])
    if @game.waiting_for_storyteller?
      if @game.current_storyteller != current_user
        waiting_for_storyteller
      else
        storyteller
      end
    end
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
end
