class RegistrationsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]

  def new
    render inertia: "Registrations/New", props: { user: User.new }
  end

  def create
    @user = User.new(user_params)
    if @user.save
      start_new_session_for @user
      redirect_to choose_avatar_path, notice: t("registrations.create.success")
    else
      render inertia: "Registrations/New", props: { user: @user, errors: @user.errors }
    end
  end

  private

  def user_params
    params.permit(:password, :password_confirmation, :nickname)
  end
end
