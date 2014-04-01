require 'spec_helper'

feature 'As an user, I want to be able to remove friends' do
  scenario 'when friend is on the list' do
    user = create(:user)
    friend = create_friend_for(user)
    visit friendships_path(as: user)

    within "#friend-#{friend.id}" do
      click_link "Remove from list"
    end

    expect(page).to have_content "Friend was removed from the list"
    expect(page).to_not have_selector "#friend-#{friend.id}"
  end
end
