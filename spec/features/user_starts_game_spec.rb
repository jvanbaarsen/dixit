require 'spec_helper'

feature 'As an user I want to be able to start a new game' do
  scenario 'When I dont have to many running games' do
    user = create(:user)
    visit root_path(as: user)

    click_link "Start new game"

    fill_in 'game_title', with: 'Example game'
    fill_in 'game_description', with: 'Super game'
    click_button 'Start new game'

    expect(page).to have_content "Game was created, please wait for players to accept the invite"
    expect(current_path).to eq root_path
    expect(user.total_games).to eq 1
  end

  scenario 'When I already have 10 games running, i cannot create another game' do
    user = create(:user)
    # TODO: Remove this stub
    User.any_instance.stub(:total_games).and_return 10

    visit new_game_path(as: user)

    expect(page).to have_content "You cannot create another game, because you already have 10 running games"
    expect(current_path).to eq root_path
  end
end
