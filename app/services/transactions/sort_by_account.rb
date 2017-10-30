# frozen_string_literal: true

module Transactions
  class SortByAccount
    include SpectreAPI
    include Devise::Controllers::Helpers

    helper_method :current_user

    def initialize(account)
      @account_id ||= account
    end

    def filter
      transactions.select { |t| t.account_id == @account_id.to_i }
    end

    def self.filter_by(account:)
      new(account).filter
    end

    private

    def transactions
      binding.pry
      @transactions ||= spectre.get('transactions').data
    end
  end
end
