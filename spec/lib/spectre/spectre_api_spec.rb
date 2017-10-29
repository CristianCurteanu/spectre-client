# frozen_string_literal: true

require 'rails_helper'

describe Spectre::API do
  let(:api_url) do
    'https://www.saltedge.com/api/v3'
  end

  let(:spectre) do
    described_class.new client_id:        'CLIENT_ID',
                        service_secret:   'SERVICE_SECRET',
                        private_pem_path: 'spec/fixtures/rspec_pem.txt',
                        api_url:          api_url
  end

  context '#new' do
    it 'should be an Spectre::API instance' do
      expect(spectre).to be_an_instance_of(Spectre::API)
    end
  end

  context '#get' do
    it 'should have get method' do
      allow(spectre).to receive(:get).with('countries').and_return(double)
      expect(spectre.get('countries')).not_to be nil
    end

    it 'should handle a response' do
      cz_data = { code: 'CZ', name: 'Czech Republic', refresh_start_time: 2 }
      stub_endpoint :get, :countries,
                    response: {
                      status: 200,
                      body:   {
                        data: [cz_data]
                      }
                    }

      response = spectre.get('countries')
      expect(response).not_to be nil
      expect(response).to be_an_instance_of(Spectre::ResponseDecorator)
      expect(response.data.first.code).to eql cz_data[:code]
      expect(response.data.first.name).to eql cz_data[:name]
      expect(response.data.first.refresh_start_time).to eql cz_data[:refresh_start_time]
    end
  end

  context '#post' do
    it 'should have a post method' do
      allow(spectre).to receive(:post).with('logins', data: 'random').and_return(double)
      expect(spectre.post('logins', data: 'random')).not_to be nil
    end

    it 'should handle a POST response' do
      stub_endpoint :post, :logins,
                    body:     { data: 'random' },
                    response: {
                      status: 201,
                      body:   {
                        data: {
                          created: 'OK'
                        }
                      }
                    }

      response = spectre.post('logins', data: 'random')
      expect(response.status).to eql 201
      expect(response.data.created).to eql 'OK'
    end
  end
end
