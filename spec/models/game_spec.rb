require 'spec_helper'

describe Game do
  describe 'Associations' do
    it { should have_many(:users).through(:participations) }
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
