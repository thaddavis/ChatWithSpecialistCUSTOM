class AddCardToStripeCustomer
  def self.call(user, stripe_customer, token)
    begin
      stripe_customer.sources.create({:source => token})
      stripe_customer.save
    rescue Stripe::StripeError => e
      user.payment_profile.errors[:stripe] << e.message
    end
  end
end
