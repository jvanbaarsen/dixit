class GamesController < ApplicationController
  before_filter :authorize

  def index
  end

  def new
    if user_can_create_game
      @game = Game.new
    else
      flash[:error] = 'You cannot create another game, because you already have 10 running games'
      redirect_to root_path
    end
  end

  def create
    @game = Game.new(game_params)
    if @game.save
      current_user.games << @game
      flash[:success] = 'Game was created, please wait for players to accept the invite'
      redirect_to root_path
    end
  end

  private

  def game_params
    params.require(:game).permit(:title, :description)
  end

  def user_can_create_game
    current_user.total_games < 10
  end
end
