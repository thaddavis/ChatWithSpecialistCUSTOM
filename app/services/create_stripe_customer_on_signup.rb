class CreateStripeCustomerOnSignup
  def self.call(user)
    begin
      plan = Plan.find_by_stripe_id('starter_plan')
      customer = Stripe::Customer.create(
        email: user.email,
        plan: plan.stripe_id
      )

      user.stripe_customer_id = customer.id
      user
    rescue Stripe::StripeError => e
      user.errors[:stripe] << e.message
      user
    end
  end
end
