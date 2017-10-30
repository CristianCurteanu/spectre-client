# frozen_string_literal: true

require 'rails_helper'

describe Login, type: :model do
  let(:valid_attributes) do
    { customer_id: 3, country_code: 'DE', provider_code: 'XF', credentials: { username: 'name' } }
  end

  it 'should have customer id' do
    expect(Login.new(valid_attributes.except(:customer_id))).not_to be_valid
  end

  it 'should have a country code' do
    expect(Login.new(valid_attributes.except(:country_code))).not_to be_valid
  end

  it 'should have a provider code' do
    expect(Login.new(valid_attributes.except(:provider_code))).not_to be_valid
  end

  it 'should have credentials' do
    expect(Login.new(valid_attributes.except(:credentials))).to be_valid
  end

  context '#create' do
    it 'should have create method' do
      mock_login = instance_double('Login')
      allow(mock_login).to receive(:create) { false }
      expect(mock_login.create).to eql false
    end

    it 'should return true if API response is 200' do
      user = user_generator.call
      login = Login.new(valid_attributes.merge(current_user: user))
      stub_endpoint :post, :logins,
                    body:     {
                      data: valid_attributes.merge(fetch_type: 'recent')
                    },
                    response: {
                      body: {
                        created: 'OK'
                      }
                    }

      expect(login.create).to eql true
    end

    it 'should return false if API response is 400' do
      user = user_generator.call
      login = Login.new(valid_attributes.merge(current_user: user))
      stub_endpoint :post, :logins,
                    body:     {
                      data: valid_attributes.merge(fetch_type: 'recent')
                    },
                    response: {
                      status: 400,
                      body:   {
                        created: 'Fail'
                      }
                    }

      expect(login.create).to eql false
      expect(login.errors.messages).not_to be_empty
    end
  end
end
