# frozen_string_literal: true

module Transactions
  class SortByLogin < ::ControllersHelper
    def initialize(login)
      @login_id = login
    end

    def filter
      filtered_accounts.flatten!
    end

    def self.filter_by(login:)
      new(login).filter
    end

    private

    def transactions
      @transactions ||= spectre.get('transactions').data || []
    end

    def accounts
      @accounts ||= spectre.get('accounts').data.select do |acc|
        acc.login_id == @login_id.to_i
      end
    end

    def filtered_accounts
      @filtered_accounts ||= accounts.each_with_object([]) do |account, result|
        result << transactions.select { |t| t.account_id == account.id }
      end
    end
  end
end
