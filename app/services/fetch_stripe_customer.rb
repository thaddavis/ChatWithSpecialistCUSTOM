class FetchStripeCustomer
  def self.call(user)
    begin
      customer = Stripe::Customer.retrieve(user.stripe_customer_id)
      customer
    rescue Stripe::StripeError => e
      user.payment_profile.errors[:stripe] << e.message
    end
  end
end
