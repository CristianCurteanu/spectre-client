# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include SpectreAPI

  before_action :authenticate_user!
  protect_from_forgery with: :exception

  private

  def create_customer
    redirect_to customers_new_path unless current_user.created_customer
  end
end
