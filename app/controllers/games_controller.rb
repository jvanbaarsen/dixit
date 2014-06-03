class GamesController < ApplicationController
  before_filter :authorize

  def index
    @running_games = current_user.running_games.order("updated_at DESC")
  end

  def show
    @game = current_user.games.find(params[:id])
    if @game.inviting?
      redirect_to new_game_invite_path(@game)
    elsif @game.waiting_for_storyteller?
      redirect_to new_game_storyteller_path(@game)
    end
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
      Participation.create!(game: @game, user: current_user, state: 'accepted')

      flash[:success] = 'Game was created, please wait for players to accept the invite'
      redirect_to new_game_invite_path(@game)
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
