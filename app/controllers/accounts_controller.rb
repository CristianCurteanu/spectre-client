# frozen_string_literal: true

class AccountsController < ApplicationController
  before_action :create_customer
  helper_method :accounts, :transactions_for

  def index
    @login ||= spectre.get("logins/#{params[:login_id]}").data
  end

  def show
    @account = spectre.get('accounts').data.find { |acc| acc.id.to_i == params[:account_id].to_i }
  end
end
