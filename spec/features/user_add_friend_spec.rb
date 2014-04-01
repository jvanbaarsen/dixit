require 'spec_helper'

feature 'As an user I want to be able to add friends' do
  scenario 'when the user if not in the list yet' do
    user = create(:user)
    friend_user = create(:user)
    visit friendships_path(as: user)

    fill_in 'email', with: friend_user.email
    click_button "Add friend"

    expect(page).to have_content "Friend was added to the list"
    expect(page).to have_content friend_user.name
  end

  scenario 'when the user is already in the list' do
    user = create(:user)
    friend = create_friend_for(user)
    visit friendships_path(as: user)

    fill_in 'email', with: friend.email
    click_button "Add friend"

    expect(page).to have_content "Friend is already on the list"
  end

  scenario 'when an unknown/invalid email is given' do
    user = create(:user)
    visit friendships_path(as: user)

    fill_in 'email', with: 'invalid_unknown_email'
    click_button "Add friend"

    expect(page).to have_content "We don't know that user, sorry!"
  end
end
