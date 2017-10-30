# frozen_string_literal: true

class ControllersHelper
  include SpectreAPI
  include Devise::Controllers::Helpers

  helper_method :current_user
end
