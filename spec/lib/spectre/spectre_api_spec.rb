require 'rails_helper'

describe Spectre::API do
  let(:api_url) do
    'http://api.example.url'
  end

  let(:headers) do
    {
      headers: {
        'Accept' => 'application/json',
        'Client-id' => 'CLIENT_ID',
        'Service-secret' => 'SERVICE_SECRET'
      }
    }
  end

  let(:spectre) do
    described_class.new client_id:      'CLIENT_ID',
                        service_secret: 'SERVICE_SECRET',
                        private_key:    File.open(Rails.root.join('spec', 'fixtures', 'rspec_pem.txt')),
                        api_url:        api_url
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
      url = [api_url, 'countries'].join('/')
      data = {
        data: [
          {
            code: 'CZ',
            name: 'Czech Republic',
            refresh_start_time: 2
          }
        ]
      }.to_json

      stub_request(:get, url)
        .with(headers).to_return(status: 200, body: data)

      response = spectre.get('countries')

      expect(response).not_to be nil
      expect(response).to be_an_instance_of(RestClient::Response)
      expect(response.body).to eql data
    end
  end

  context '#post' do
    it 'should have a post method' do
      allow(spectre).to receive(:post).with('logins', data: 'random').and_return(double)
      expect(spectre.post('logins', data: 'random')).not_to be nil
    end

    it 'should handle a POST response' do
      url = [api_url, 'logins'].join('/')
      params = {
        data: 'random'
      }

      stub_request(:post, url)
        .with(headers).to_return(status: 201, body: 'OK')

      response = spectre.post('logins', params)
      expect(response.code).to eql 201
      expect(response.body).to eql 'OK'
    end
  end
end