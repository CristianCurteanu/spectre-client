# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  include SpectreAPI

  def create
    super do |resource|
      Customer.new(identifier: resource.email).create
      resource.added_new_customer
    end
  end

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
    root_path
  end
end
