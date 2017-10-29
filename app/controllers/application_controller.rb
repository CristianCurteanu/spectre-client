# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include SpectreAPI
  include CustomersHelper

  before_action :authenticate_user!
  protect_from_forgery with: :exception

  rescue_from NoMethodError do
    render 'exceptions/application_error'
  end

  private

  def create_customer
    redirect_to customers_new_path unless current_user.created_customer
  end
end
