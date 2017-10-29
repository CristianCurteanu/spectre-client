# frozen_string_literal: true

module ApiHelpers
  # An example
  # stub_endpoint :get, :countries,
  #               response: {
  #                 status: 200,
  #                 body: {
  #                   data: [
  #                     {
  #                       code:               'CZ',
  #                       name:               'Czech Republic',
  #                       refresh_start_time: 2
  #                     }
  #                   ]
  #                 }
  #               }
  def stub_endpoint(method, *args)
    options = args.extract_options!
    if options.key? :headers
      options[:headers].merge!(headers)
    else
      options[:headers] = headers
    end

    if args.first.is_a?(Symbol) || args.first.is_a?(Array)
      endpoint = Array(args.shift).unshift(mock_url).join('/')
      options[:location] = endpoint.dasherize.to_s
      options[:method] = method
    end

    stub_with_options options
  end

  private

  def stub_with_options(options)
    options[:response][:body] = options[:response][:body].to_json
    options[:response][:status] = options[:response][:status] || 200
    stub_request(options[:method], options[:location]).
      with({ headers: options[:headers] }.merge!(body: options[:body])).
      to_return(options[:response])
  end

  def mock_url
    @mock_url ||= 'https://www.saltedge.com/api/v3'
  end

  def headers
    @headers ||= {
      'Accept'         => 'application/json',
      'Content-type'   => 'application/json',
      'Client-id'      => 'CLIENT_ID',
      'Service-secret' => 'SERVICE_SECRET'
    }
  end
end
