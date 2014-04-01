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

  def destroy
    friend = current_user.friends.find(params[:id])
    current_user.remove_friend!(friend)
    flash[:success] = 'Friend was removed from the list'
  rescue UserNotOnFriendListError
    flash[:error] = 'User is not on your friendlist'
  ensure
    redirect_to friendships_path
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
