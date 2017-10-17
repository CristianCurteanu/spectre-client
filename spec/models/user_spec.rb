require 'rails_helper'

describe User, type: :model do
  it 'should have email' do
    User.new(email: nil).should_not be_valid
  end

  it 'should have password' do
    User.new(email: 'random@email.com', password: nil).should_not be_valid
  end

  it 'should have password confirmation' do
    User.new(email: 'random@email.com', password: 'test', password_confirmation: nil).should_not be_valid
  end
end
