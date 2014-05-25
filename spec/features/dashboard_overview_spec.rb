require 'spec_helper'

feature 'Player dashboard' do
  scenario 'Player sees his the running games' do
    user = create(:user)
    game = create_game_for(user)
    visit root_path(as: user)

    within '.running-games' do
      expect(page).to have_selector ".story-#{game.id}"
    end
  end

  scenario 'Game card should show usefull info' do
    user = create(:user)
    game = create_game_for(user, :invite)
    visit root_path(as: user)

    within ".story-#{game.id}" do
      expect(page).to have_content game.title
      expect(page).to have_content game.description
      within '.participants' do
        expect(page).to have_content user.name
        expect(page).to have_content game.users.first.name
      end
    end
  end
end