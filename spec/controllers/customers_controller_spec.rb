# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CustomersController, type: :controller do
  describe 'GET #index' do
    it 'returns http success' do
      sign_in_user

      stub_endpoint :get, :customers,
                    response: {
                      status: 200,
                      body:   {
                        data: nil
                      }
                    }
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'should redirect to create customer page if customer was not added' do
      sign_in user_generator.call
      get :index
      expect(response.status).to eql 302
      expect(response.location).to eql customers_new_url
    end
  end

  describe 'GET #new' do
    it 'returns http success' do
      sign_in user_generator.call
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #show' do
    it 'returns http success' do
      sign_in_user

      stub_endpoint :get, [:customers, '3212'],
                    response: {
                      status: 200,
                      body:   {
                        data: {
                          customer_id: 3212
                        }
                      }
                    }

      get 'show', params: { id: 3212 }
      expect(response).to have_http_status(:success)
    end

    it 'should redirect to create customer page if customer was not added' do
      sign_in user_generator.call
      get 'show', params: { id: 3212 }
      expect(response.status).to eql 302
      expect(response.location).to eql customers_new_url
    end
  end

  describe 'POST #create' do
    it 'redirects to customers index page if customer is created' do
      sign_in_user

      stub_endpoint :post, :customers,
                    body:     {
                      data: {
                        identifier: 'some_string'
                      }
                    },
                    response: {
                      status: 200,
                      body:   {
                        created: 'OK'
                      }
                    }

      post :create, params: { customer: { identifier: 'some_string' } }
      expect(response.status).to eql 302
      expect(response.location).to eql customers_index_url
    end

    it 'redirects to customer new page if customer is not created' do
      request.env['HTTP_REFERER'] = customers_new_url
      sign_in_user

      stub_endpoint :post, :customers,
                    body:     {
                      data: {
                        identifier: 'some_string'
                      }
                    },
                    response: {
                      status: 400,
                      body:   {
                        error: 'Fail'
                      }
                    }

      post :create, params: { customer: { identifier: 'some_string' } }
      expect(response.status).to eql 302
      expect(response.location).to eql customers_new_url
    end

    it 'should redirect to customer new page if customer is not valid' do
      request.env['HTTP_REFERER'] = customers_new_url
      sign_in_user
      post :create, params: { customer: { identifier: nil } }
      expect(response.status).to eql 302
      expect(response.location).to eql customers_new_url
    end

    it 'should redirect to create customer page if customer was not added' do
      sign_in user_generator.call
      post :create
      expect(response.status).to eql 302
      expect(response.location).to eql customers_new_url
    end
  end

  describe 'GET #destroy' do
    it 'redirects to index if customer deleted' do
      sign_in_user
      stub_endpoint :delete, [:customers, '3212'],
                    response: {
                      status: 200,
                      body:   {
                        data: {
                          deleted: true
                        }
                      }
                    }

      get :destroy, params: { id: 3212 }
      expect(response.status).to eql 302
      expect(response.location).to eql customers_index_url
    end

    it 'redirects to index if customer deleted' do
      sign_in_user
      stub_endpoint :delete, [:customers, '3212'],
                    response: {
                      status: 200,
                      body:   {
                        data: {
                          deleted: false
                        }
                      }
                    }

      get :destroy, params: { id: 3212 }
      expect(response.status).to eql 302
      expect(response.location).to eql customers_show_url(3212)
    end

    it 'should redirect to create customer page if customer was not added' do
      sign_in user_generator.call
      get :destroy, params: { id: 3212 }
      expect(response.status).to eql 302
      expect(response.location).to eql customers_new_url
    end
  end
end
