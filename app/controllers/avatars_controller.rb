class AvatarsController < ApplicationController
  def new
    render inertia: "Avatars/Choose"
  end

  def create
    if Current.user.update(avatar_url: params[:avatar_url])
      redirect_to after_authentication_url, notice: t("avatars.create.success")
    else
      redirect_to choose_avatar_path, alert: t("avatars.create.error")
    end
  end
end
