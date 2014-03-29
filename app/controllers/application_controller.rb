class ApplicationController < ActionController::Base
  include Clearance::Controller
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  layout :determine_layout

  private

  def determine_layout
    if signed_in?
      "application"
    else
      "login"
    end
  end
end
