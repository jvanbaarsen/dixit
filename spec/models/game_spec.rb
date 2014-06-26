require 'spec_helper'

describe Game do
  describe 'Associations' do
    it { should have_many(:users).through(:participations) }
    it { should have_many(:rounds) }
  end

  describe '#invite_player' do
    it 'creates a participant if the given user was not already on the list' do
      game = create(:game)
      user = create(:user)
      game.invite_player(user)
      expect(game.participations.count).to eq 1
      expect(game.participations.last.state).to eq "pending"
    end

    it 'returns false if user is already a participant' do
      game = create(:game)
      user = create(:user)
      game.invite_player(user)
      expect(game.invite_player(user)).to be_false
    end
  end

  describe '#authors' do
    it 'returns an array with author names' do
      game = create(:game_with_invites)
      user = create(:user)
      game.invite_player(user)

      names = game.users.collect(&:name)

      expect(game.authors).to eq names
    end
  end

  describe '#send_invitations' do
    context 'with the state `New`' do
      it 'calls the InviteWorker' do
        game = create(:game_with_invites)
        expect(InvitationWorker).to receive(:perform_async)
        game.send_invitations
      end
    end

    context 'with another state then `New`' do
      it 'wont call the InviteWorker' do
        game = create(:game_with_invites)
        game.invites_send!
        expect(InvitationWorker).not_to receive(:perform_async)
        game.send_invitations
      end
    end
  end

  describe '#formatted_state' do
    it 'returns "Waiting for you to invite players" when status is new' do
      game = build(:game)
      expect(game.formatted_state).to eq "Waiting for you to invite players"
    end

    it 'returns "Waiting for players to accept their invite" when status is invites_send' do
      game = build(:game, state: 'invites_send')
      expect(game.formatted_state).to eq 'Waiting for players to accept their invite'
    end

    it 'returns "Waiting for storyteller" when status is waiting_for_storyteller' do
      game = build(:game, state: 'waiting_for_storyteller')
      expect(game.formatted_state).to eq 'Waiting for storyteller'
    end

    it 'returns "Waiting for votes" when status is waiting_for_votes' do
      game = build(:game, state: 'waiting_for_votes')
      expect(game.formatted_state).to eq 'Waiting for votes'
    end

    it 'returns "Game is finished" when status is finished' do
      game = build(:game, state: 'finished')
      expect(game.formatted_state).to eq 'Game is finished'
    end
  end

  describe '#prepare_round' do
    it 'creates a new round' do
      game = create(:game, state: 'invites_send')
      create_player_for(game)

      expect(game.rounds.count).to eq 0
      game.prepare_round
      expect(game.rounds.count).to eq 1
      expect(game.state).to eq 'waiting_for_storyteller'
    end
  end

  describe '#current_storyteller' do
    it 'returns the current storyteller' do
      game = create(:game, state: 'waiting_for_storyteller')
      user = create_player_for(game)
      create_player_for(game)
      game.prepare_round
      set_storyteller(game, user)
      expect(game.current_storyteller).to eq user
    end

    it 'returns an empty user if there is no current round or storyteller' do
      game = create(:game)
      expect(game.current_storyteller).to be_a User
      expect(game.current_storyteller.persisted?).to be_false
    end
  end

  describe '#current_round' do
    it 'returns the current round' do
      game = create(:game, state: 'waiting_for_storyteller')
      create_player_for(game)
      game.prepare_round
      game.prepare_round
      round = Round.last
      expect(game.current_round).to eq round
    end
  end

  describe '#player_submitted_picture?' do
    it 'returns true if the player has submitted a picture' do
      game = create(:game, state: 'waiting_for_players')
      user = create_player_for(game)
      game.prepare_round
      game.current_round.picture_for_user(user).update(flickr_id: 1)
      expect(game.player_submitted_picture?(user)).to be_true
    end

    it 'returns false if player has not submitted picture yet' do
      game = create(:game, state: 'waiting_for_players')
      user = create_player_for(game)
      game.prepare_round
      expect(game.player_submitted_picture?(user)).to be_false
    end
  end

  describe ".running" do
    it 'returns not finished games' do
      new_game = create(:game)
      finished_game = create(:finished_game)
      invites_send = create(:game, state: :invites_send)
      games = Game.running
      expect(games).to include(invites_send)
      expect(games).not_to include(finished_game)
      expect(games).not_to include(new_game)
    end
  end
end
