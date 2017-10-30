# frozen_string_literal: true

class TransactionsController < ApplicationController
  def index
    key = params.except(:controller, :action).keys.first
    @transactions = if key.present?
                      send("sort_by_#{key.gsub('_id', '')}")
                    else
                      spectre.get('transactions').data
                    end
  end

  private

  def sort_by_login
    Transactions::SortByLogin.filter_by(login: params['login_id'])
  end

  def sort_by_account
    Transactions::SortByAccount.filter_by(account: params['account_id'])
  end
end
