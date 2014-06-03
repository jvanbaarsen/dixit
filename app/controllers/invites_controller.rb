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
      flash.now[:success] = 'Player has been added to the invite list!'
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

  def accept
    handle_invite do
      invite.accept_invite
      flash[:success] = 'You have accepted your invite'
    end
  end

  def deny
    handle_invite do
      invite.deny_invite
      flash[:success] = 'You have denied your invite'
    end
  end

  def send_invites
    game = current_user.games.find(params[:game_id])
    game.send_invitations
    flash[:success] = 'All the invites have been send, just wait for everyone to reply'
    redirect_to root_path
  end

  private

  def handle_invite
    if invite.pending?
      yield
    else
      flash[:success] = 'You have already replied to this invite'
    end
    redirect_to root_path
  end

  def invite
    @invite ||= Participation.find_by(game_id: params[:game_id], user_id: current_user)
  end

  def find_user
    if params[:friend_id].present?
      @friend = current_user.friends.find(params[:friend_id])
    else
      @friend = User.find_by!(email: params[:email])
    end
  end
end
