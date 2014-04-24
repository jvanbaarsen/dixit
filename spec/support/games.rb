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
end
