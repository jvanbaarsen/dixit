require 'spec_helper'

describe Game do
  describe 'Associations' do
    it { should have_many(:users).through(:participations) }
  end

  describe '#invite_player' do
    it 'creates a participant if the given user was not already on the list' do
      game = create(:game)
      user = create(:user)
      game.invite_player(user)
      expect(game.participations.count).to eq 1
    end

    it 'returns false if user is already a participant' do
      game = create(:game)
      user = create(:user)
      game.invite_player(user)
      expect(game.invite_player(user)).to be_false
    end
  end

  describe ".running" do
    it 'returns not finished games' do
      game = create(:game)
      finished_game = create(:finished_game)
      games = Game.running
      expect(games).to include(game)
      expect(games).not_to include(finished_game)
    end
  end
end
