class ChangePlan
  def self.call(user, stripe_customer, stripe_subscription_id, from_plan, to_plan)
    return if user.subscriptions.find { |s| s.plan_id == Plan.find_by_stripe_id(to_plan).id}

    begin

      customer = stripe_customer
      customerJSON = JSON.parse(customer.to_s)

      if customerJSON['subscriptions']
        subscriptionStripe = customerJSON['subscriptions']['data'].find {
          |s| s['id'] == stripe_subscription_id
        }
      end

      if subscriptionStripe
        stripe_sub = customer.subscriptions.retrieve(subscriptionStripe['id'])
        stripe_sub.plan = to_plan
        stripe_sub.save
      end

    rescue Stripe::StripeError => e
      user.payment_profile.errors[:stripe] << e.message
    end
  end
end
