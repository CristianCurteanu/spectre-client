class Customer
  include ActiveModel::Model
  include SpectreAPI

  attr_accessor :identifier, :current_user

  validates :identifier, presence: true

  def create
    if self.valid?
      return true if spectre.post('customers', post_data).status == 200
      self.errors.add :invalid_request, 'is invalid'
    else
      false
    end
  end

  def post_data
    @post_data ||= { data: { identifier: self.identifier }}
  end
end