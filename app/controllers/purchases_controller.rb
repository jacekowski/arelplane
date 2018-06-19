class PurchasesController < ApplicationController
  before_action :set_purchase, only: :show

  def create
    @amount = 1499
    customer = Stripe::Customer.create(
      email: params[:stripeEmail],
      source: params[:stripeToken]
    )

    if current_user
      user = current_user
    else
      user = User.find_by(email: params[:stripeEmail])
    end
    @purchase = Purchase.create(
      user_id: user.try(:id),
      email: params[:stripeEmail],
      amount: 1499,
      address_city: params[:stripeShippingAddressCity],
      address_country: params[:stripeShippingAddressCountry],
      address_line1: params[:stripeShippingAddressLine1],
      address_state: params[:stripeShippingAddressState],
      address_zip: params[:stripeShippingAddressZip],
      brand: customer[:cards][:data][0][:brand],
    )

    charge = Stripe::Charge.create(
      customer:    customer.id,
      amount:      @amount,
      description: 'CRAFTpad Purchase',
      currency:    'usd'
    )

    # charge = Stripe::Order.create(
    #   customer: customer.id,
    #   currency: 'usd',
    #   items: [
    #     {
    #       type: 'sku',
    #       parent: 'sku_D4c53F5LQqaYuP'
    #     }
    #   ],
    #   shipping: {
    #     name: params[:stripeShippingName],
    #     address: {
    #       line1: params[:stripeShippingAddressLine1],
    #       line2: params[:stripeShippingAddressLine2],
    #       city: params[:stripeShippingAddressCity],
    #       state: params[:stripeShippingAddressState],
    #       country: params[:stripeShippingAddressCountry],
    #       postal_code: params[:stripeShippingAddressZip]
    #     }
    #   },
    #   email: params[:stripeEmail]
    # )

    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to craftpad_path
  end

  def show
  end

private
  def set_purchase
    @purchase = Purchase.find(params[:id])
  end

end
