class StorypanelsController < ApplicationController
  def create
    @game = current_user.games.find(params[:game_id])
    @round = @game.current_round
    if @game.current_storyteller == current_user
      @round.update(story_fragment: params[:storyfragment])
      @round.picture_for_user(current_user).update(flickr_id: params[:flickr_id])
      @game.waiting_for_players!
      flash[:success] = 'Your story has been created!'
    else
      flash[:error] = 'You\'re not the storyteller.. cheater!'
    end
    redirect_to root_path
  end
end
