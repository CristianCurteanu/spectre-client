class CustomersController < ApplicationController
  before_action :create_customer, except: :new

  def index
    @customers = spectre.get('customers').data
  end

  def new
    @customer ||= Customer.new
  end

  def show
    @customer = spectre.get("customers/#{params[:id]}").data
  end

  def create
    @customer = Customer.new(customer_params.merge!(current_user: current_user))
    if @customer.create
      current_user.added_new_customer
      redirect_to root_path
    else
      render :new
    end
  end

  private

  def customer_params
    @customer_params ||= params.require(:customer).permit(:identifier)
  end
end
