# frozen_string_literal: true

require 'rails_helper'

describe TransactionsController, type: :controller do
  describe '#index' do
    before do
      sign_in_user
      stub_endpoint :get, :transactions,
                    response: {
                      body: {
                        data:
                              [
                                { id: 1, account_id: 32_123 },
                                { id: 2, account_id: 321 },
                                { id: 3, account_id: 321 },
                                { id: 4, account_id: 321_321 }
                              ]
                      }
                    }
      stub_endpoint :get, :accounts,
                    response: {
                      body: {
                        data: [
                          {
                            login_id: 10,
                            provider: 'fakebank_account_simple',
                            extra:    {
                              transactions_count: {
                                key_1: 4,
                                key_2: 7
                              }
                            }
                          }
                        ]
                      }
                    }
    end

    it 'should return success' do
      get :index
      expect(response.status).to eql 200
    end

    it 'should return success when a login_id parameter given' do
      get :index, params: { login_id: 10 }
      expect(response.status).to eql 200
    end

    it 'should return success when an account_id parameter given' do
      get :index, params: { account_id: 321 }
      expect(response.status).to eql 200
    end
  end
end
