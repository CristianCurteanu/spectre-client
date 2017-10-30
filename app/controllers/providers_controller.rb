# frozen_string_literal: true

class ProvidersController < ApplicationController
  def fields
    @fields = spectre.get("providers/#{params[:provider_id]}").data.
              required_fields.sort_by!(&:position)
    render partial: 'logins/providers_credentials', fields: @required_fields
  end
end
