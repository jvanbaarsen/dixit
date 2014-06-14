class RoundsController < ApplicationController
  before_filter :load_game, only: [:index, :show]

  def index
    @rounds = @game.rounds
  end

  def show
    @round = @game.rounds.find(params[:id])
    if @game.waiting_for_storyteller? && @game.current_storyteller != current_user
      waiting_for_storyteller
    end
  end

  private

  def load_game
    @game = current_user.games.find(params[:game_id])
  end

  def waiting_for_storyteller
    @state = 'waiting_for_storyteller'
  end
end
