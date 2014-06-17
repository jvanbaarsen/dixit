class Round < ActiveRecord::Base
  belongs_to :game
  has_many :submitted_pictures

  def prepare(players)
    self.update(round_number: game.rounds.count)

    players.each do |player|
      SubmittedPicture.create(user: player, round: self)
    end
    random_picture = SubmittedPicture.where(round: self).order('RANDOM()').first
    random_picture.update(start_picture: true, has_voted: true)
  end

  def storyteller
    submitted_pictures.where(start_picture: true).first.user
  end

  def number
    self.round_number
  end

  def picture_for_user(user)
    submitted_pictures.where(user: user).first
  end

  def player_voted?(user)
    submitted_pictures.where(user: user).first.has_voted?
  end

  def finished?
    submitted_pictures.where(final_picture: true).count == 1
  end
end
