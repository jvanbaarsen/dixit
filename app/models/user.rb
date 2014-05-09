Clearance::User::Validations.module_eval do
  def self.included(base)
    base.class_eval do
      validates :email,
            presence: true,
            uniqueness: { allow_blank: true },
            unless: :email_optional?
      validates :email, email: { strict_mode: true }, if: -> {email.present?}
      validates :password, presence: true, unless: :skip_password_validation?
    end
  end
end

class User < ActiveRecord::Base
  include Clearance::User

  validates :name, presence: true

  has_many :friendships
  has_many :friends, through: :friendships

  has_many :participations
  has_many :games, through: :participations

  def total_games
    self.games.count
  end

  def running_games
    self.games.running
  end

  def add_friend!(friend)
    unless self.friends.include?(friend)
      self.friends << friend
    else
      raise FriendAlreadyInListError
    end
  end

  def remove_friend!(friend)
    if self.friends.include?(friend)
      self.friends.delete(friend)
    else
      raise UserNotOnFriendListError
    end
  end
end

class FriendAlreadyInListError < StandardError
end

class UserNotOnFriendListError < StandardError
end

