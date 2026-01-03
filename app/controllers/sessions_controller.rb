class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[new create]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: t("sessions.create.rate_limit") }

  def new
    render inertia: "Sessions/New"
  end

  def create
    user = authenticate_user

    if user
      start_new_session_for(user)
      redirect_to after_authentication_url
    else
      redirect_to new_session_path, alert: t("sessions.create.alert")
    end
  end

  def destroy
    terminate_session
    redirect_to new_session_path
  end

  private

  def authenticate_user
    login = params[:login]
    password = params[:password]

    User.authenticate_by(nickname: login, password:) ||
      User.authenticate_by(email_address: login, password:)
  end
end
