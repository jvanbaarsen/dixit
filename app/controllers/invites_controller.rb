class InvitesController < ApplicationController
  before_filter :authorize

  def new
    @game = current_user.games.find(params[:game_id])
    @invites = @game.users.where.not(id: current_user)
    @friends = current_user.friends.where.not(id: @invites.collect(&:id))
  end

  def create
    @game = current_user.games.find(params[:game_id])
    @friend = find_user
    if @game.invite_player(@friend)
      @invite_status = true
      flash.now[:success] = 'Invite has been send!'
    else
      @invite_status = false
      flash.now[:error] = 'Player could not be invited. sorry!'
    end
  rescue ActiveRecord::RecordNotFound
    @invite_status = false
    flash.now[:error] = 'Player does not exist. Sorry!'
  end

  def destroy
    @game = current_user.games.find(params[:game_id])
    @game.users.delete(params[:user_id])
    redirect_to game_path(@game)
  end

  private

  def find_user
    if params[:friend_id].present?
      @friend = current_user.friends.find(params[:friend_id])
    else
      @friend = User.find_by!(email: params[:email])
    end
  end
end
