# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  private

  def sign_up_params
    params.require(:user).permit(*valid_params)
  end

  def account_update_params
    params.require(:user).permit(*valid_params.push(:current_password))
  end

  def valid_params
    %i[client_id service_secret email password password_confirmation]
  end

  protected

  def after_sign_up_path_for(_resource)
    user_dashboard_path
  end
end
