module SpectreAPI
  extend ActiveSupport::Concern

  def spectre
    return unless current_user
    @spectre ||= Spectre::API.new client_id: current_user.client_id,
                                  service_secret: current_user.service_secret,
                                  private_pem_path: 'private.pem',
                                  api_url: 'https://www.saltedge.com/api/v3'
  end
end