require 'spec_helper'

describe Game do
  describe 'Associations' do
    it { should have_many(:users).through(:participations) }
  end
end
