class PurchasesController < ApplicationController
  before_action :set_purchase, only: :show

  def create
    @amount = 1499
    customer = Stripe::Customer.create(
      email: params[:stripeEmail],
      source: params[:stripeToken]
    )

    charge = Stripe::Order.create(
      customer: customer.id,
      currency: 'usd',
      items: [
        {
          type: 'sku',
          parent: 'sku_D4c53F5LQqaYuP'
        }
      ],
      shipping: {
        name: params[:stripeShippingName],
        address: {
          line1: params[:stripeShippingAddressLine1],
          line2: params[:stripeShippingAddressLine2],
          city: params[:stripeShippingAddressCity],
          state: params[:stripeShippingAddressState],
          country: params[:stripeShippingAddressCountry],
          postal_code: params[:stripeShippingAddressZip]
        }
      },
      email: params[:stripeEmail]
    )

    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to craftpad_path

    if current_user
      user = current_user
    else
      user = User.find_by(email: params[:stripeEmail])
    end
    @purchase = Purchase.new(
      user_id: user.try(:id),
      email: params[:stripeEmail],
      amount: charge["amount"],
      object: charge["object"],
      amount_refunded: charge["amount_refunded"],
      address_city: charge["source"]["address_city"],
      address_country: charge["source"]["address_country"],
      address_line1: charge["source"]["address_line1"],
      address_line2: charge["source"]["address_line2"],
      address_state: charge["source"]["address_state"],
      address_zip: charge["source"]["address_zip"],
      brand: charge["source"]["brand"],
      country: charge["source"]["country"],
      description: charge["description"]
    )
    if @purchase.save
      respond_to do |format|
        format.html { redirect_to @purchase, notice: 'Purchase Successful!' }
      end
    end
  end

  def show
  end

private
  def set_purchase
    @purchase = Purchase.find(params[:id])
  end

end
