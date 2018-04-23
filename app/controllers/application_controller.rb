class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from Twitter::Error::TooManyRequests, with: :tweet_reach_limit

  before_action :require_login

  def tweet_reach_limit
    render 'static_pages/tweet_reach_limit', status: 500
  end

  def hello
    render text: "hello, world!"
  end

  helper_method :current_user

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def require_login
    unless logged_in?
      redirect_to(root_path)
    end
  end

end
