require 'spec_helper'

describe SubmittedPicture do
  describe 'Associations' do
    it { should belong_to :user }
    it { should belong_to :round }
  end
end
