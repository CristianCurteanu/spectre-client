# frozen_string_literal: true

module SessionsHelper
  def sign_in_user
    user = user_generator.call
    user.added_new_customer
    sign_in user
  end
end
