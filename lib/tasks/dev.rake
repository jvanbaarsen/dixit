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
    
    user = FactoryGirl.create(:user, name: "John Doe", email: "john.doe@example.com")
    puts_user user

    user = FactoryGirl.create(:user, name: "Piet", email: "piet@example.com")
    puts_user user

    user = FactoryGirl.create(:user, name: "Jeroen van Baarsen", email: "jeroen@example.com")
    puts_user user
  end

  def header(msg)
    puts "\n\n*** #{msg.upcase} *** \n\n"
  end

  def puts_user(user)
    puts "#{user.name}<#{user.email}> / #{user.password}"
  end
end
