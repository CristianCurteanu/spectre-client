class TransactionsController < ApplicationController
  def index
    key = params.except(:controller, :action).keys.first
    @transactions = if key.present?
                      self.send("sort_by_#{key.gsub('_id', '')}")
                    else
                      spectre.get('transactions').data
                    end
  end

  private

  def sort_by_login
    transactions = spectre.get('transactions').data
    accounts = spectre.get('accounts').data.select do |acc|
      acc.login_id == params['login_id'].to_i
    end
    accounts.each_with_object([]) do |account, result|
      result << transactions.select { |t| t.account_id == account.id }
    end.flatten!
  end

  def sort_by_account
    spectre.get('transactions').data.select do |transaction|
      transaction.account_id == params['account_id'].to_i
    end
  end
end