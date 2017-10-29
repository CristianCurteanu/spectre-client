# frozen_string_literal: true

class SubmitReconnect
  def initialize(params:, spectre:)
    @params ||= params
    @spectre ||= spectre
  end

  def type
    @type ||= update.status == 200 ? :success : :error
  end

  def message
    @message ||= { success: 'Customer is reconnected', error: update.body.error_message }[type]
  end

  private

  def body
    @body ||= { data: { credentials: @params.except(:login_id).to_h } }
  end

  def path
    @path ||= ['logins', @params[:login_id], 'reconnect'].join('/')
  end

  def update
    @update ||= @spectre.put(path, body)
  end
end
