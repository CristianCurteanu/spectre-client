# frozen_string_literal: true

require 'rails_helper'

describe Customer, type: :model do
  it 'should have an identifier' do
    expect(Customer.new(identifier: nil)).not_to be_valid
  end

  context '#create' do
    it 'should have create method' do
      customer = Customer.new(identifier: 'some_string')
      allow(customer).to receive(:create) { false }
      expect(customer.create).to eql false
    end

    it 'should return true if API response is 200' do
      user = user_generator.call
      customer = Customer.new(identifier: 'some_string', current_user: user)
      stub_endpoint :post, :customers,
                    body:     {
                      data: {
                        identifier: 'some_string'
                      }
                    },
                    response: {
                      body: {
                        created: 'OK'
                      }
                    }

      expect(customer.create).to eql true
    end

    it 'should return false if API response is 400' do
      user = user_generator.call
      customer = Customer.new(identifier: 'some_string', current_user: user)
      stub_endpoint :post, :customers,
                    body:     {
                      data: {
                        identifier: 'some_string'
                      }
                    },
                    response: {
                      status: 400,
                      body:   {
                        created: 'Fail'
                      }
                    }

      expect(customer.create).to eql false
      expect(customer.errors.messages).not_to be_empty
    end
  end
end
