class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:create]
  def create
    auth = request.env['omniauth.auth']
    user = User.find_or_create_from_auth_hash(auth)
    session[:user_id] = user.id
    session[:oauth_token] = auth.credentials.token
    session[:oauth_token_secret] = auth.credentials.secret
    flash[:success] = 'ログインしました。'
    redirect_to(root_path)
  end

  def destroy
   reset_session
   flash[:info] = 'ログアウトしました。'
   redirect_to(root_path)
  end
end
