module Games
  def create_game_for(user, type = :new)
    case type
    when :new
      game = create(:game)
    when :invite
      game = create(:game_with_invites)
    end
    user.games << game
    game
  end

  def accept_all_invites(game)
    game.participations.each do |invite|
      invite.update(state: 'accepted')
    end
  end

  def create_player_for(game)
    user = create(:user)
    Participation.create!(game: game, user: user, state: 'accepted')
    user
  end
end
