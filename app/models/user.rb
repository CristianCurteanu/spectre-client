# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :validatable

  validates :client_id, :service_secret, presence: true

  def added_new_customer
    self.created_customer = true
    save!
  end
end
