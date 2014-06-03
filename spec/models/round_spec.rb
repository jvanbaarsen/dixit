require 'spec_helper'

describe Round do
  describe 'Associations' do
    it { should belong_to :game }
    it { should have_many :submitted_pictures }
  end

  describe '#prepare' do
    it 'creates a submittedPicture for every participant' do
      game = create(:game)
      users = []
      4.times { users << create_player_for(game) }
      round = Round.create(game: game)
      round.prepare(users)
      expect(round.submitted_pictures.count).to eq 4
    end

    it 'picks a random player as the storyteller' do
      game = create(:game)
      users = []
      4.times { users << create_player_for(game) }
      round = Round.create(game: game)
      round.prepare(users)
      story_teller = SubmittedPicture.where(round: round.id).where(start_picture: true)
      expect(story_teller.count).to eq 1
    end
  end

  describe '#storyteller' do
    it 'returns the storyteller for this round' do
      game = create(:game)
      users = []
      users << create_player_for(game)
      users << create_player_for(game)
      round = Round.create(game: game)
      round.prepare(users)
      set_storyteller(game, users.first)
      expect(round.storyteller).to eq users.first
    end
  end

  describe '#number' do
    it 'returns the current round number' do
      game = create(:game)
      user = create_player_for(game)
      rounds = []
      4.times { rounds << Round.create(game: game) }
      rounds.last.prepare([user])
      expect(rounds.last.number).to eq 4
    end
  end
end
