module Spectre
  class API
    EXPIRATION_TIME = 60

    attr_reader :client_id, :service_secret, :private_key, :api_url

    def initialize(client_id:, service_secret:, private_key:, api_url:)
      @client_id = client_id
      @service_secret = service_secret
      @private_key = private_key
      @api_url = api_url
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

    def signature
      @signature ||= Base64.encode64(rsa_digest.sign(*sha1_digest)).delete("\n")
    end

    private

    def path_url(path)
      [api_url, path].join('/')
    end

    def sha1_digest
      @sha1_digest ||= [OpenSSL::Digest::SHA1.new,
                        "#{@hash[:expires_at]}|#{@hash[:method]}|#{@hash[:url]}|#{@hash[:params]}"]
    end

    def rsa_digest
      @rsa_digest ||= OpenSSL::PKey::RSA.new(@private_key)
    end

    def request(method, url, params = {})
      @hash ||= {
        method:     method,
        url:        url,
        expires_at: (Time.now + EXPIRATION_TIME).to_i,
        params:     params.to_json
      }
      RestClient::Request.execute(
        method:  @hash[:method],
        url:     @hash[:url],
        payload: @hash[:params],
        headers: {
          'Accept'         => 'application/json',
          'Content-type'   => 'application/json',
          'Expires-at'     => @hash[:expires_at],
          'Signature'      => signature,
          'Client-id'      => client_id,
          'Service-secret' => service_secret
        }
      )
    end
  end
end
