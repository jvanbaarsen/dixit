class AppMailer < ActionMailer::Base
  default from: "jeroenvanbaarsen+dixit@gmail.com"

  def game_invite(game, user)
    @game = game
    mail to: user.email
  end
end
