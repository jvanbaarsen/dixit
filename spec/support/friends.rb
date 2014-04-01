module Friends
  def create_friend_for(user)
    friend = create(:user)
    user.friends << friend
    friend
  end
end
