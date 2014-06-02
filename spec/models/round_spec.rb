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
end
