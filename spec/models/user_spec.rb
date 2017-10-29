# frozen_string_literal: true

require 'rails_helper'

describe User, type: :model do
  it 'should have email' do
    expect(User.new(email: nil)).not_to be_valid
  end

  it 'should have password' do
    expect(User.new(email: 'random@email.com', password: nil)).not_to be_valid
  end

  it 'should have password confirmation' do
    expect(User.new(email: 'random@email.com', password: 'test', password_confirmation: nil)).not_to be_valid
  end
end
