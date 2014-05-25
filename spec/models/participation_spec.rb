require 'spec_helper'

describe Participation do
  describe 'Associations' do
    it { should belong_to :game }
    it { should belong_to :user }
  end

  describe '#create_invitation' do
    it 'Adds a user to a game' do
      game = create(:game)
      user = create(:user)
      Participation.create_invitation(game, user)
      expect(game.participations.count).to eq 1
    end
  end

  describe '#accept_invite' do
    it 'changes the state to :accepted and call CheckInvitesWorker' do
      game = create(:game_with_invites_send)
      participation = game.participations.last
      expect(CheckInvitesWorker).to receive(:perform_async)
      participation.accept_invite
      expect(participation.accepted?).to be_true
    end
  end

  describe '#deny_invite' do
    it 'changes the state to :denied and call CheckInvitesWorker' do
      game = create(:game_with_invites_send)
      participation = game.participations.last
      expect(CheckInvitesWorker).to receive(:perform_async)
      participation.deny_invite
      expect(participation.denied?).to be_true
    end
  end
end
