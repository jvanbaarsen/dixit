class FriendshipsController < ApplicationController
  before_filter :authorize

  def index
    load_friends
  end

  def create
    friend = User.find_by!(email: params[:email])
    current_user.add_friend!(friend)
    flash[:success] = 'Friend was added to the list'
    redirect_to friendships_path
  rescue FriendAlreadyInListError
    render_friend_add_error 'Friend is already on the list'
  rescue ActiveRecord::RecordNotFound
    render_friend_add_error "We don't know that user, sorry!"
  end

  private

  def render_friend_add_error(msg)
    load_friends
    flash.now[:error] = msg
    render :index
  end

  def load_friends
    @friends ||= current_user.friends
  end
end
