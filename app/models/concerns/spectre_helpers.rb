# frozen_string_literal: true

module SpectreHelpers
  extend ActiveSupport::Concern

  def create
    if valid?
      return true if spectre.post(create_url, post_data).status == 200
      errors.add :invalid_request, 'is invalid'
    else
      false
    end
  end
end
