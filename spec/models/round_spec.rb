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

  describe '#picture_for_user' do
    it 'returns the image belonging to a user' do
      game = create(:game)
      users = []
      users << create_player_for(game)
      users << create_player_for(game)
      round = Round.create(game: game)
      round.prepare(users)
      user_picture = SubmittedPicture.where(round: round.id).where(user_id: users.first.id)
      expect(round.picture_for_user(users.first)).to eq user_picture.first
    end
  end

  describe '#player_voted?' do
    it 'returns true if the player has voted' do
      game = create(:game)
      user = create_player_for(game)
      round = Round.create(game: game)
      round.prepare([user])
      SubmittedPicture.where(round: round.id).where(user_id: user.id).first.update(has_voted: true)
      expect(round.player_voted?(user)).to be_true
    end
  end

  describe '#finished?' do
    it 'returns true if the game has finished' do
      game = create(:game)
      user = create_player_for(game)
      round = Round.create(game: game)
      round.prepare([user])
      SubmittedPicture.where(round: round.id).where(user_id: user.id).first.update(final_picture: true)
      expect(round.finished?).to be_true
    end
  end
end
