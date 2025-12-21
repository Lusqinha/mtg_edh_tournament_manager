class ProfilesController < ApplicationController
  def update
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

  private

  def password_params
    params.permit(:password, :password_confirmation)
  end
end
