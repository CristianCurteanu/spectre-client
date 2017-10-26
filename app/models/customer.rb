# frozen_string_literal: true

class Customer
  include ActiveModel::Model
  include SpectreAPI
  include SpectreHelpers

  attr_accessor :identifier, :current_user

  validates :identifier, presence: true

  private

  def create_url
    'customers'
  end

  def post_data
    @post_data ||= { data: { identifier: identifier } }
  end
end
