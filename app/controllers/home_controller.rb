class HomeController < ApplicationController
  include SpectreAPI

  def index
    @client ||= spectre.get('client/info').data
  end
end
