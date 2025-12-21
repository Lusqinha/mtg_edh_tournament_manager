class ProfilesController < ApplicationController
  def update
    if params[:password].present?
      update_password
    else
      update_profile
    end
  end

  private

  def update_password
    if Current.user.authenticate(params[:current_password])
      if Current.user.update(password_params)
        redirect_to user_path(Current.user), notice: "Senha atualizada com sucesso."
      else
        redirect_to user_path(Current.user), alert: "Erro ao atualizar senha: #{Current.user.errors.full_messages.join(', ')}"
      end
    else
      redirect_to user_path(Current.user), alert: "Senha atual incorreta."
    end
  end

  def update_profile
    if Current.user.update(profile_params)
      redirect_to user_path(Current.user), notice: "Perfil atualizado com sucesso."
    else
      redirect_to user_path(Current.user), alert: "Erro ao atualizar perfil: #{Current.user.errors.full_messages.join(', ')}"
    end
  end

  def password_params
    params.permit(:password, :password_confirmation)
  end

  def profile_params
    params.permit(:nickname)
  end
end
