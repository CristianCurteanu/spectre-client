# frozen_string_literal: true

class LoginsController < ApplicationController
  helper_method :customer, :accounts

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
    @transactions_count = accounts.each_with_object([]) do |account, result|
      result << transactions_for(account)
    end.sum
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
    redirect_to :back
  end

  def reconnect
    @login  ||= spectre.get("logins/#{params[:id]}").data
    @fields ||= spectre.get("providers/#{@login.provider_code}").data.required_fields.
                sort_by!(&:position)
  end

  def submit_reconnect
    body = { data: { credentials: reconnect_params.except(:login_id).to_h } }
    update = spectre.put("logins/#{params[:reconnect][:login_id]}/reconnect", body)
    if update.status == 200
      flash[:success] = 'Customer is reconnected'
      redirect_to logins_index_path
    else
      flash[:error] = update.body.error_message
      redirect_to :back
    end
  end

  def destroy
    type = spectre.delete("logins/#{params[:id]}").data.removed ? :success : :error
    flash[type] = t("logins.destroy.messages.#{type}")
    redirect_to :back
  end

  private

  # TODO: refactor to a faster way
  def customer(id)
    @customers.find { |c| c.id == id }
  end

  def login_params
    credentials = params.require(:login).require(:credentials)
    params.require(:login).permit(:customer_id, :country_code, :provider_code, :credentials).
      merge!(credentials: credentials.permit(credentials.keys))
  end

  def reconnect_params
    fields = spectre.get("providers/#{params[:reconnect][:provider_code]}").data.
             required_fields.each_with_object([]) { |el, result| result << el.name }
    params.require(:reconnect).permit([:login_id].push(fields).flatten)
  end
end
