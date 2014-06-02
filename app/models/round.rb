class Round < ActiveRecord::Base
  belongs_to :game
  has_many :submitted_pictures

  def prepare(players)
    players.each do |player|
      SubmittedPicture.create(user: player, round: self)
    end
    random_picture = SubmittedPicture.where(round: self).order('RANDOM()').first
    random_picture.update(start_picture: true)
  end
end
