# frozen_string_literal: true

module Spectre
  class ResponseDecorator
    def initialize(object)
      @object ||= object
    end

    def status
      @object.status
    end

    def data
      @data ||= body.data || []
    end

    def body
      @body ||= Dish(JSON.parse(@object.body))
    end

    def headers
      Dish(@object.headers)
    end

    def request
      @object.request
    end
  end
end
