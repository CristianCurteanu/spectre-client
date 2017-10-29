# frozen_string_literal: true

require 'rails_helper'

describe AccountsController, type: :controller do
  before do
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

  describe '#index' do
    let(:login_id) { 3000 }

    it 'should return success if there are accounts for login' do
      sign_in_user

      stub_endpoint :get, [:logins, login_id],
                    response: {
                      body: {
                        data: {
                          id:          10,
                          customer_id: 133
                        }
                      }
                    }

      get :index, params: { login_id: login_id }

      expect(response.status).to eql 200
    end

    it 'should redirect to create customer page if customer was not added' do
      sign_in user_generator.call
      get :index, params: { login_id: login_id }
      expect(response.status).to eql 302
      expect(response.location).to eql customers_new_url
    end
  end

  describe '#show' do
    it 'should return success' do
      sign_in_user

      get :show, params: { account_id: 32_321 }

      expect(response.status).to eql 200
    end

    it 'should redirect to create customer page if customer was not added' do
      sign_in user_generator.call
      get :show, params: { account_id: 32_321 }
      expect(response.status).to eql 302
      expect(response.location).to eql customers_new_url
    end
  end
end
