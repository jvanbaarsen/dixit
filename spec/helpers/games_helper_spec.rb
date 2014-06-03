require 'spec_helper'

describe GamesHelper do
  describe '#format_game_state' do
    let(:user) { User.new }
    it 'returns "Waiting for you to invite players" when status is new' do
      game = create_game_with_state('inviting')
      expect(helper.format_game_state(game, user)).to eq "Waiting for you to invite players"
    end

    it 'returns "Waiting for players to accept their invite" when status is invites_send' do
      game = create_game_with_state('invites_send')
      expect(helper.format_game_state(game, user)).to eq 'Waiting for players to accept their invite'
    end

    it 'returns "Waiting for storyteller" when status is waiting_for_storyteller' do
      game = create_game_with_state('waiting_for_storyteller')
      expect(helper.format_game_state(game, user)).to eq 'Waiting for storyteller'
    end

    it 'returns "Waiting for votes" when status is waiting_for_votes' do
      game = create_game_with_state('waiting_for_votes')
      expect(helper.format_game_state(game, user)).to eq 'Waiting for votes'
    end

    it 'returns "Game is finished" when status is finished' do
      game = create_game_with_state('finished')
      expect(helper.format_game_state(game, user)).to eq 'Game is finished'
    end

    it 'returns "You\'re the storyteller, everyone is waiting for you!" when you\'r the storyteller' do
      game = create_game_with_state('waiting_for_storyteller')
      expect(helper.format_game_state(game, @user)).to eq 'You\'re the storyteller, everyone is waiting for you!'
    end
  end

  def create_game_with_state(state)
    game = create(:game, state: state)
    @user = create_player_for(game)
    game.prepare_round
    game.update(state: state)
    game
  end
end
