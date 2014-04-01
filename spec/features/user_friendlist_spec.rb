require 'spec_helper'

feature 'User views his friendlist' do
  scenario 'with friends' do
    user = signed_in_user
    friend = create_friend_for(user)

    click_link 'Friends'

    expect(current_path).to eq friendships_path
    expect(page).to have_content("#{friend.name}")
  end

  scenario 'with no friends' do
    user = signed_in_user

    click_link 'Friends'

    expect(page).to have_content("You don't have any friends yet.")
  end
end
