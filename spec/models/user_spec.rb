require 'spec_helper'

describe User do
  describe 'Validations' do
    it { should validate_presence_of(:password) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:name) }
  end

  describe 'Associations' do
    it { should have_many(:friends).through(:friendships) }
  end

  describe '#add_friend!' do
    context 'when friend is not yet in friendlist' do
      it 'Add the given friend to the friendlist' do
        user = create(:user)
        friend = create(:user)
        expect {
          user.add_friend!(friend)
        }.to change(user.friends, :count).by(1)
      end
    end

    context 'when friend is already in friendlist' do
      it 'raises a FriendAlreadyInListError' do
        user = create(:user)
        friend = create(:user)
        user.add_friend!(friend)
        expect {
          user.add_friend!(friend)
        }.to raise_error FriendAlreadyInListError
      end
    end
  end
end
