require 'rest-client'

module Spectre
  class API
    EXPIRATION_TIME = 60

    attr_reader :client_id,
                :service_secret,
                :api_url,
                :response
                :private_pem_path

    def initialize(client_id:, service_secret:, private_pem_path:, api_url:)
      @client_id = client_id
      @service_secret = service_secret
      @api_url = api_url
      @private_pem_path = private_pem_path
    end

    def get(path, params = {})
      request('GET', path_url(path), params)
    end

    def post(path, params = {})
      request('POST', path_url(path), params)
    end

    def put(path, params = {})
      request('PUT', path_url(path), params)
    end

    def delete(path, params = {})
      request('DELETE', path_url(path), params)
    end

    # TODO: Fix 400 response with Signature header
    def signature
      @signature ||= Base64.encode64(
        OpenSSL::PKey::RSA.new(File.open(Rails.root.join(@private_pem_path)))
                          .sign(OpenSSL::Digest::SHA1.new, encodable)).delete("\n")
    end

    private

    def path_url(path)
      [api_url, path].join('/')
    end

    def encodable
      "#{@request_hash[:expires_at]}|#{@request_hash[:method]}|#{@request_hash[:url]}|#{@request_hash[:params]}"
    end

    def request(method, url, params = {})
      @request_hash = {
        method:     method.downcase.to_sym,
        url:        url,
        expires_at: (Time.now + EXPIRATION_TIME).to_i,
        params:     params.empty? ? '' : params.to_json
      }
      ResponseDecorator.new RestClient::Request.execute request_data
    rescue RestClient::BadRequest
      false
    end

    def request_data
      {
        method:  @request_hash[:method],
          url:     @request_hash[:url],
          payload: @request_hash[:params],
          headers: {
            'Accept'         => 'application/json',
            'Content-type'   => 'application/json',
            'Expires-at'     => @request_hash[:expires_at],
            # 'Signature'      => signature,
            'Client-id'      => client_id,
            'Service-secret' => service_secret
          }
      }
    end
  end
end
