# frozen_string_literal: true

class LoginsController < ApplicationController
  before_action :create_customer
  helper_method :accounts

  def new
    @countries ||= spectre.get('countries').data
    @providers ||= spectre.get('providers').data
    @customers ||= spectre.get('customers').data
  end

  def index
    @logins = if params[:customer_id]
                spectre.get('logins').data.select do |login|
                  login.customer_id == params[:customer_id].to_i
                end
              else
                spectre.get('logins').data
              end
    @customers ||= spectre.get('customers').data
  end

  def show
    @login    ||= spectre.get("logins/#{params[:id]}").data
    @customer ||= spectre.get("customers/#{@login.customer_id}").data
    @transactions_count ||= transactions_counting.sum
  end

  def create
    if Login.new(login_params.merge!(current_user: current_user)).create
      redirect_to logins_index_path
    else
      redirect_to logins_new_path
    end
  end

  def refresh
    type = spectre.put("logins/#{params[:id]}/refresh").status == 200 ? :success : :error
    flash[type] = t("logins.refresh.messages.#{type}")
    redirect_back fallback_location: logins_index_path
  end

  def reconnect
    @login  ||= spectre.get("logins/#{params[:id]}").data
    @fields ||= spectre.get("providers/#{@login.provider_code}").data.required_fields.
                sort_by!(&:position)
  end

  def submit_reconnect
    submit = SubmitReconnect.new(params: reconnect_params, spectre: spectre)
    flash[submit.type] = submit.message
    redirect_to({ success: logins_index_path,
                  error:   logins_reconnect_path(reconnect_params[:login_id]) }[submit.type])
  end

  def destroy
    type = spectre.delete("logins/#{params[:id]}").data.try(:removed) ? :success : :error
    flash[type] = t("logins.destroy.messages.#{type}")
    redirect_back fallback_location: logins_index_path
  end

  private

  def login_params
    if params[:login][:credentials].nil?
      params.require(:login).permit(:customer_id, :country_code, :provider_code)
    else
      params.require(:login).permit(:customer_id, :country_code, :provider_code, :credentials).
        merge!(credentials: login_credentials.permit(login_credentials.keys))
    end

  end

  def reconnect_params
    params.require(:reconnect).permit([:login_id].push(provider_fields).flatten)
  end

  def provider_fields
    @provider_fields ||= spectre.get("providers/#{params[:reconnect][:provider_code]}").data.
                         required_fields.each_with_object([]) { |el, result| result << el.name }
  end

  def login_credentials
    @login_credentials ||= params.require(:login).require(:credentials)
  end

  def transactions_counting
    @transactions_counting ||= accounts.each_with_object([]) do |account, result|
      result << transactions_for(account)
    end
  end
end
