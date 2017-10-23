class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :client_id, :service_secret, presence: true

  def added_new_customer
    self.created_customer = true
    self.save!
  end
end
