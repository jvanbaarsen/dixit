require 'spec_helper'

feature 'Invited player accepts or denies game invite' do
  scenario 'Player accepts invite' do
    game = create(:game_with_invites_send)
    user = game.users.first
    visit accept_game_invite_path(game, as: user)
    expect(current_path).to eq root_path
    expect(page).to have_content "You have accepted your invite"
  end

  scenario 'Player denies invite' do
    game = create(:game_with_invites_send)
    user = game.users.first
    visit deny_game_invite_path(game, as: user)
    expect(current_path).to eq root_path
    expect(page).to have_content "You have denied your invite"
  end

  scenario 'Player has already replied to its invite' do
    game = create(:game_with_invites_send)
    user = game.users.first
    invite = game.participations.first

    invite.accepted!
    visit accept_game_invite_path(game, as: user)
    expect(current_path).to eq root_path
    expect(page).to have_content 'You have already replied to this invite'

    visit deny_game_invite_path(game, as: user)
    expect(current_path).to eq root_path
    expect(page).to have_content 'You have already replied to this invite'
  end
end
