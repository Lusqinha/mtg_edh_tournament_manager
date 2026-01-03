class ProfilesController < ApplicationController
  def update
    params[:password].present? ? update_password : update_profile
  end

  private

  def update_password
    unless Current.user.authenticate(params[:current_password])
      return redirect_to profile_path, alert: t("profiles.update.password_incorrect")
    end

    if Current.user.update(password_params)
      redirect_to profile_path, notice: t("profiles.update.password_success")
    else
      redirect_to profile_path, alert: t("profiles.update.password_error", errors: error_messages)
    end
  end

  def update_profile
    if Current.user.update(profile_params)
      redirect_to profile_path, notice: t("profiles.update.success")
    else
      redirect_to profile_path, alert: t("profiles.update.error", errors: error_messages)
    end
  end

  def profile_path
    user_path(uuid: Current.user.uuid)
  end

  def error_messages
    Current.user.errors.full_messages.to_sentence
  end

  def password_params
    params.permit(:password, :password_confirmation)
  end

  def profile_params
    params.permit(:nickname, :avatar_url)
  end
end
