class ApplicationController < ActionController::Base
  include SpectreAPI

  protect_from_forgery with: :exception

  private

  def create_customer
    redirect_to customers_new_path unless current_user.created_customer
  end
end
