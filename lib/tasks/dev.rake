namespace :dev do
  desc "Create sample data for local development"
  task seed: ['db:setup'] do
    unless Rails.env.development?
      raise "This task can only be run in the development environment"
    end

    require 'factory_girl_rails'

    create_users
  end

  def create_users
    header "Users"
   
    10.times do
      puts_user FactoryGirl.create(:user)
    end

    # Create one known user
    user = FactoryGirl.create(:user, name: "Jeroen van Baarsen", email: "jeroen@example.com")
    user.add_friend!(User.first)
    puts_user user
  end

  def header(msg)
    puts "\n\n*** #{msg.upcase} *** \n\n"
  end

  def puts_user(user)
    puts "#{user.name}<#{user.email}> / #{user.password}"
  end
end
