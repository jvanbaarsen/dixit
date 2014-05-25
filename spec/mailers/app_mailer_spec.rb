require "spec_helper"

describe AppMailer do
  describe "game_invite" do
    it "renders the headers" do
      game = create(:game)
      user = create(:user)

      mail = AppMailer.game_invite(game, user)
      expect(mail.subject).to eq "Game invite"
      expect(mail.to).to eq [user.email]
      expect(mail.from).to eq ["jeroenvanbaarsen+dixit@gmail.com"]
    end
  end
end
