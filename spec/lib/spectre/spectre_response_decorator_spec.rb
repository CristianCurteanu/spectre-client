# frozen_string_literal: true

require 'rails_helper'

describe Spectre::ResponseDecorator do
  before do
    @decorated_response ||= described_class.new instance_double('Faraday::Response')
  end

  describe '#headers' do
    before do
      @headers ||= instance_double('Faraday::ResponseHeaders')
      allow(@decorated_response).to receive(:headers) { @headers }
    end

    it 'should have response headers' do
      expect(@decorated_response.headers).to eql(@headers)
    end
  end

  describe '#request' do
    before do
      @request ||= instance_double('Faraday::Request')
      allow(@decorated_response).to receive(:request) { @request }
    end

    it 'should have request object' do
      expect(@decorated_response.request).to eql(@request)
    end
  end
end
