module Games
  def create_game_for(user)
    game = create(:game)
    user.games << game
    game
  end
end
