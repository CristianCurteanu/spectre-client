# frozen_string_literal: true

module ModelGenerators
  def user_generator
    lambda do
      User.create! email:    Faker::Internet.email,
                   password: Faker::Internet.password
    end
  end
end
