# frozen_string_literal: true

class HomeController < ApplicationController
  before_action :create_customer

  def index
    @client ||= spectre.get('client/info').data
  end
end
