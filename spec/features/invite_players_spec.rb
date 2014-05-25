require 'spec_helper'

feature 'Invite players for a game' do
  scenario 'Via friend list', js: true do
    user = create(:user)
    friend = create_friend_for(user)
    friend2 = create_friend_for(user)
    game = create_game_for(user)
    visit game_path(game, as: user)

    expect(current_path).to eq new_game_invite_path(game)

    expect(page).to have_content "Invite your friends"
    expect(page).to have_selector ".js-friend-#{friend.id}"
    expect(page).to have_selector ".js-friend-#{friend2.id}"

    click_link "add-friend-#{friend.id}"
    within('.js-invite-box-friend') do
      expect(page).not_to have_content friend.name
    end
    within('.js-current-invites') do
      expect(page).not_to have_content user.name
      expect(page).to have_content "#{friend.name}"
    end
  end

  scenario 'Via existing email', js: true do
    user = create(:user)
    another_user = create(:user)
    game = create_game_for(user)
    visit game_path(game, as: user)

    fill_in 'email', with: another_user.email
    click_button 'Add user to the game'

    expect(page).to have_content 'Player has been added to the invite list!'
    within('.js-current-invites') do
      expect(page).to have_content another_user.name
    end
  end

  scenario 'Remove a player from the invitation list', js: true do
    user = create(:user)
    another_user = create_friend_for(user)
    game = create_game_for(user)
    game.invite_player(another_user)
    visit game_path(game, as: user)

    within('.js-current-invites') do
      expect(page).to have_content another_user.name
      click_link "remove-invite-#{another_user.id}"
    end

    within('.js-invite-box-friend') do
      expect(page).to have_content another_user.name
    end
  end

  scenario 'Send out all the invitations', js: true do
    user = create(:user)
    another_user = create_friend_for(user)
    game = create_game_for(user)
    game.invite_player(another_user)
    visit game_path(game, as: user)

    click_link "Send the invites"
    expect(current_path).to eq root_path
    expect(page).to have_content 'All the invites have been send, just wait for everyone to reply'
    game.reload
    expect(game.state).to eq 'invites_send'
  end
end
