class FriendshipsController < ApplicationController
  before_filter :authorize

  def index
    @friends = current_user.friends
  end
end
