require 'spec_helper'

feature 'As an user I want to be able to start a new game' do
  context 'When I dont have to many running games' do
    scenario 'Give game a name and description' do
      user = create(:user)
      visit root_path(as: user)

      click_link "Start new game"

      fill_in 'game_title', with: 'Example game'
      fill_in 'game_description', with: 'Super game'
      click_button 'Start new game'
      game = user.games.last
      expect(user.total_games).to eq 1
      expect(game.state).to eq "new"
      expect(current_path).to eq new_game_invite_path(game)
    end

    context 'Invite player' do
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
        friend.reload
        expect(friend.total_games).to eq 1
        game.reload
        expect(game.state).to eq 'invites_send'
      end

      scenario 'Via existing email', js: true do
        user = create(:user)
        another_user = create(:user)
        game = create_game_for(user)
        visit game_path(game, as: user)

        fill_in 'email', with: another_user.email
        click_button 'Sent invite'

        expect(page).to have_content 'Invite has been send!'
        within('.js-current-invites') do
          expect(page).to have_content another_user.name
        end
      end
    end
  end

  context 'When i have to many running games' do
    scenario 'When I already have 10 games running, i cannot create another game' do
      user = create(:user)
      User.any_instance.stub(:total_games).and_return 10

      visit new_game_path(as: user)

      expect(page).to have_content "You cannot create another game, because you already have 10 running games"
      expect(current_path).to eq root_path
    end
  end
end
