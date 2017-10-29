# frozen_string_literal: true

module CustomersHelper
  # TODO: refactor to a faster way
  def customer(id)
    @customers.find { |c| c.id == id }
  end
end
