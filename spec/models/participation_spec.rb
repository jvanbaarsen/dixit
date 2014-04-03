require 'spec_helper'

describe Participation do
  describe 'Associations' do
    it { should belong_to :game }
    it { should belong_to :user }
  end
end
