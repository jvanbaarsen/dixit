module GamesHelper
  def format_game_state(game, user)
    if game.state == 'waiting_for_storyteller' && game.current_storyteller == user
      I18n.t "game_status.waiting_for_you_storyteller"
    elsif game.state == 'waiting_for_players' && game.rounds.last.picture_for_user(user).try(:flickr_id).nil?
        I18n.t "game_status.waiting_for_your_picture"
    else
      I18n.t "game_status.#{game.state}"
    end
  end
end
