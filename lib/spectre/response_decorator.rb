module Spectre
  class ResponseDecorator
    def initialize(object)
      @object ||= object
    end

    def status
      @object.code
    end

    def data
      Dish(JSON.parse(@object.body)['data'])
    end

    def headers
      Dish(@object.headers)
    end

    def request
      @object.request
    end
  end
end