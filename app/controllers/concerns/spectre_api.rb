# frozen_string_literal: true

module SpectreAPI
  extend ActiveSupport::Concern

  def spectre
    @spectre ||= Spectre::API.new client_id:        'ZQQYsUaQUhIXZvuf0_tK0A',
                                  service_secret:   '4smHNZzWpmjx3P-pLmWS6Pvd82j7_9VBwiIyA-1pL9Y',
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
