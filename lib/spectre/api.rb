# frozen_string_literal: true

module Spectre
  class API
    EXPIRATION_TIME = 60

    attr_reader :client_id,
                :service_secret,
                :api_url,
                :response,
                :private_pem_path

    def initialize(client_id:, service_secret:, private_pem_path:, api_url:)
      @client_id = client_id
      @service_secret = service_secret
      @api_url = api_url
      @private_pem_path = File.open(Rails.root.join(private_pem_path))
    end

    def get(path, params = {})
      request(:get, path, params)
    end

    def post(path, params = {})
      request(:post, path, params)
    end

    def put(path, params = {})
      request(:put, path, params)
    end

    def delete(path, params = {})
      request(:delete, path, params)
    end

    def signature
      @signature ||= Signature.sign(rsa, encodable)
    end

    def verify
      Signature.verify(OpenSSL::PKey::RSA.new(public_pem_path), encodable, signature)
    end

    private

    def public_pem
      @public_pem ||= File.read(Rails.root.join('public.pem'))
    end

    def rsa
      @rsa ||= OpenSSL::PKey::RSA.new(@private_pem_path)
    end

    def encodable
      @encodable ||= "#{@request_hash[:expires_at].to_i}|#{@request_hash[:method].to_s.upcase}|" \
                     "#{[api_url, @request_hash[:url]].join}|#{@request_hash[:params]}"
    end

    def request(method, url, params)
      @request_hash = {
        method:     method,
        url:        "/api/v3/#{url}",
        expires_at: (Time.zone.now + EXPIRATION_TIME).to_i,
        params:     params.empty? ? '' : params.to_json
      }
      response = connection.send(@request_hash[:method]) do |req|
        req.url url
        req.headers = request_data[:headers]
        req.body = request_data[:payload]
      end
      ResponseDecorator.new(response)
    end

    def request_data
      @request_data = {
        method:  @request_hash[:method],
        url:     @request_hash[:url],
        payload: @request_hash[:params],
        headers: {
          'Accept'         => 'application/json',
          'Content-type'   => 'application/json',
          'Expires-at'     => @request_hash[:expires_at].to_s,
          # 'Signature'      => signature,
          'Client-id'      => client_id,
          'Service-secret' => service_secret
        }
      }
    end

    def connection
      @connection ||= Faraday.new url: api_url do |faraday|
        faraday.use :http_cache, store: Rails.cache
        faraday.adapter Faraday.default_adapter
      end
    end
  end
end
