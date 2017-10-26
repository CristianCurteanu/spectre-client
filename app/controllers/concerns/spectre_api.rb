# frozen_string_literal: true

module SpectreAPI
  extend ActiveSupport::Concern

  def spectre
    return unless current_user
    @spectre ||= Spectre::API.new client_id:        current_user.client_id,
                                  service_secret:   current_user.service_secret,
                                  private_pem_path: 'private.pem',
                                  api_url:          'https://www.saltedge.com/api/v3'
  end

  def accounts
    return unless defined?(@login)
    @accounts ||= spectre.get('accounts').data.select { |acc| acc.login_id == @login.id }
  end

  def transactions_for(account)
    account.extra.transactions_count.to_h.values.sum
  end
end
