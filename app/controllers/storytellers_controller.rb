class StorytellersController < ApplicationController
  def new
    @game = current_user.games.find(params[:game_id])
    check_storyteller
    @rounds = [Round.new(round_number: 1),
               Round.new(round_number: 2),
               Round.new(round_number: 3),
               Round.new(round_number: 4),
               Round.new(round_number: 5)]
  end

  def create

  end

  private

  def check_storyteller
    if @game.current_storyteller != current_user
      redirect_to game_path(@game) and return
    end
  end
end
