class SubmittedPicturesController < ApplicationController
  def update
    game = current_user.games.find(params[:game_id])
    round = game.current_round
    if !game.player_submitted_picture?(current_user)
      picture = round.picture_for_user(current_user)
      picture.update(flickr_id: params[:flickr_id])
      flash[:success] = 'Your picture has been saved'
      CheckGameStateWorker.perform_async(game.id)
    end
    redirect_to game_path(game)
  end
end
