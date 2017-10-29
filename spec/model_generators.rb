# frozen_string_literal: true

module ModelGenerators
  def user_generator
    lambda do
      User.create! email:          Faker::Internet.email,
                   password:       Faker::Internet.password,
                   client_id:      'CLIENT_ID',
                   service_secret: 'SERVICE_SECRET'
    end
  end
end
