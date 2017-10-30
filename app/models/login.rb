# frozen_string_literal: true

class Login
  include ActiveModel::Model
  include SpectreAPI
  include SpectreHelpers

  attr_accessor :current_user,
                :customer_id,
                :country_code,
                :provider_code,
                :credentials

  validates :customer_id, :country_code, :provider_code, presence: true

  def create_url
    'logins'
  end

  def post_data
    @post_data ||= { data: {
      customer_id:   customer_id.to_i,
      country_code:  country_code,
      provider_code: provider_code,
      fetch_type:    'recent',
      credentials:   credentials || {}
    } }
  end
end
