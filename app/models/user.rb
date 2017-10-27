# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :validatable

  def added_new_customer
    self.created_customer = true
    save!
  end
end
