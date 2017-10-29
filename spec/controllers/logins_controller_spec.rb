# frozen_string_literal: true

require 'rails_helper'

describe LoginsController, type: :controller do
  describe '#new' do
    it 'should return success' do
      sign_in_user

      stub_endpoint :get, :countries, response: { body: { data: nil } }
      stub_endpoint :get, :providers, response: { body: { data: nil } }
      stub_endpoint :get, :customers, response: { body: { data: nil } }

      get :new
      expect(response.status).to eql 200
    end

    it 'should redirect to create customer page if customer was not added' do
      sign_in user_generator.call
      get :new
      expect(response.status).to eql 302
      expect(response.location).to eql customers_new_url
    end
  end

  describe '#index' do
    before do
      sign_in_user
      stub_endpoint :get, :customers, response: { body: { data: nil } }
    end

    it 'should return OK' do
      stub_endpoint :get, :logins,
                    response: {
                      body: {
                        data: nil
                      }
                    }
      get :index
      expect(response.status).to eql 200
    end

    it 'should return OK if there is a customer' do
      stub_endpoint :get, :logins,
                    response: {
                      body: {
                        data: [
                          {
                            customer_id: 133
                          }
                        ]
                      }
                    }
      get :index, params: { customer_id: 133 }
      expect(response.status).to eql 200
    end

    it 'should redirect to create customer page if customer was not added' do
      sign_in user_generator.call
      get :index
      expect(response.status).to eql 302
      expect(response.location).to eql customers_new_url
    end
  end

  describe '#show' do
    it 'should return success' do
      sign_in_user
      stub_endpoint :get, [:logins, '1234'],
                    response: {
                      body: {
                        data: {
                          id:          10,
                          customer_id: 133
                        }
                      }
                    }
      stub_endpoint :get, [:customers, '133'],
                    response: {
                      body: { data: nil }
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

      get :show, params: { id: 1234 }
      expect(response.status).to eql 200
    end
  end

  describe '#create' do
    it 'should redirect to logins index path if login is created' do
      sign_in_user

      params = {
        login: {
          customer_id:   2321,
          country_code:  'US',
          provider_code: 'XF',
          credentials:   {
            login:    'username',
            password: 'secret'
          }
        }
      }

      stub_endpoint :post, :logins,
                    body:     {
                      data: params[:login].merge(fetch_type: 'recent')
                    },
                    response: { status: 200, body: { data: 'OK' } }

      post :create, params: params
      expect(response.status).to eql 302
      expect(response.location).to eql logins_index_url
    end

    it 'should redirect to logins new path if login wasn\'t created' do
      sign_in_user

      params = {
        login: {
          customer_id:   2321,
          country_code:  'US',
          provider_code: 'XF',
          credentials:   {
            login:    'username',
            password: 'secret'
          }
        }
      }

      stub_endpoint :post, :logins,
                    body:     {
                      data: params[:login].merge(fetch_type: 'recent')
                    },
                    response: { status: 400, body: { data: 'Fail' } }

      post :create, params: params
      expect(response.status).to eql 302
      expect(response.location).to eql logins_new_url
    end

    it 'should redirect to logins new path if login is not valid' do
      sign_in_user
      post :create, params: { login: { credentials: { val: nil } } }
      expect(response.status).to eql 302
      expect(response.location).to eql logins_new_url
    end
  end

  describe '#refresh' do
    it 'should redirect to logins index page if refresh was successfull' do
      sign_in_user

      stub_endpoint :put, [:logins, 233, :refresh],
                    response: {
                      body: {
                        data: 'OK'
                      }
                    }

      put :refresh, params: { id: 233 }
      expect(response.status).to eql 302
      expect(response.location).to eql logins_index_url
      expect(flash[:success]).to eql I18n.t('logins.refresh.messages.success')
    end

    it 'should redirect to logins index page if refresh was successfull' do
      sign_in_user

      stub_endpoint :put, [:logins, 233, :refresh],
                    response: {
                      status: 400,
                      body:   {
                        data: 'Fail'
                      }
                    }

      put :refresh, params: { id: 233 }
      expect(response.status).to eql 302
      expect(response.location).to eql logins_index_url
      expect(flash[:error]).to eql I18n.t('logins.refresh.messages.error')
    end
  end

  describe '#reconnect' do
    it 'should return http success' do
      sign_in_user

      stub_endpoint :get, [:logins, 4312],
                    response: {
                      body: {
                        data: {
                          provider_code: 'fakebank'
                        }
                      }
                    }

      stub_endpoint :get, %i[providers fakebank],
                    response: {
                      body: {
                        data: {
                          name: 'Fake Bank Simple'
                        }
                      }
                    }

      get :reconnect, params: { id: 4312 }
      expect(response.status).to eql 200
    end

    it 'should renders exceptions/application_error if logins data is nil' do
      sign_in_user

      stub_endpoint :get, [:logins, 4312],
                    response: {
                      body: {
                        data: nil
                      }
                    }
      get :reconnect, params: { id: 4312 }
      expect(response.status).to eql 200
      expect(response).to render_template 'exceptions/application_error'
    end
  end

  describe '#submit_reconnect' do
    before do
      sign_in_user
      @params ||= {
        reconnect: {
          login_id:      4312,
          provider_code: 'fakebank',
          login:         'username',
          password:      'secret'
        }
      }
      stub_endpoint :get, %i[providers fakebank],
                    response: {
                      body: {
                        data: {
                          required_fields: [{ name: 'login' }, { name: 'password' }]
                        }
                      }
                    }
    end

    it 'should redirect to logins index path' do
      sign_in_user
      @params ||= {
        reconnect: {
          login_id:      4312,
          provider_code: 'fakebank',
          login:         'username',
          password:      'secret'
        }
      }
      stub_endpoint :get, %i[providers fakebank],
                    response: {
                      body: {
                        data: {
                          required_fields: [{ name: 'login' }, { name: 'password' }]
                        }
                      }
                    }

      stub_endpoint :put, [:logins, 4312, :reconnect],
                    body:     {
                      data: {
                        credentials: @params[:reconnect].slice(:login, :password)
                      }
                    },
                    response: {
                      status: 200,
                      body:   {
                        data: {
                          created: 'OK'
                        }
                      }
                    }

      post :submit_reconnect, params: @params
      expect(response.status).to eql 302
      expect(response.location).to eql logins_index_url
      expect(flash[:success]).to eql 'Customer is reconnected'
    end

    it 'should redirect to logins index path' do
      stub_endpoint :put, [:logins, 4312, :reconnect],
                    body:     {
                      data: {
                        credentials: @params[:reconnect].slice(:login, :password)
                      }
                    },
                    response: {
                      status: 400,
                      body:   {
                        error_message: 'Failed to reconnect'
                      }
                    }

      post :submit_reconnect, params: @params
      expect(response.status).to eql 302
      expect(response.location).to eql logins_reconnect_url(4312)
      expect(flash[:error]).to eql 'Failed to reconnect'
    end
  end

  describe '#destroy' do
    let(:login_id) { 3213 }

    before do
      sign_in_user
    end

    it 'should redirect to logins index with success message' do
      stub_endpoint :delete, [:logins, login_id],
                    response: {
                      body: {
                        data: {
                          removed: true
                        }
                      }
                    }

      get :destroy, params: { id: login_id }
      expect(response.status).to eql 302
      expect(response.location).to eql logins_index_url
      expect(flash[:success]).to eql I18n.t('logins.destroy.messages.success')
    end

    it 'should redirect with fail message if request failed' do
      stub_endpoint :delete, [:logins, login_id],
                    response: {
                      status: 400,
                      body:   {
                        data: nil
                      }
                    }

      get :destroy, params: { id: login_id }
      expect(response.status).to eql 302
      expect(response.location).to eql logins_index_url
      expect(flash[:error]).to eql I18n.t('logins.destroy.messages.error')
    end

    it 'should redirect with fail message if request removed attribute is false' do
      stub_endpoint :delete, [:logins, login_id],
                    response: {
                      body: {
                        data: {
                          removed: false
                        }
                      }
                    }

      get :destroy, params: { id: login_id }
      expect(response.status).to eql 302
      expect(response.location).to eql logins_index_url
      expect(flash[:error]).to eql I18n.t('logins.destroy.messages.error')
    end
  end
end
