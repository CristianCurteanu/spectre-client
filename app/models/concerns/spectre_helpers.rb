# frozen_string_literal: true

module SpectreHelpers
  extend ActiveSupport::Concern

  def create
    return true if valid? && spectre.post(create_url, post_data).status == 200
    errors.add :invalid_request, 'is invalid'
    false
  end
end
