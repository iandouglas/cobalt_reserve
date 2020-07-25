class ApplicationController < ActionController::Base
  helper_method :current_user,
                :current_campaign

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def current_campaign
    @current_campaign ||= Campaign.find_by(status: "active")
  end
end
