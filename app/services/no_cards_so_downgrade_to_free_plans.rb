class NoCardsSoDowngradeToFreePlans
  def self.call(user, stripe_customer)
    begin

      if stripe_customer.subscriptions
        stripe_customer.subscriptions.each do |s|
          s.plan = 'starter_plan'
          s.save
        end
      end

    rescue Stripe::StripeError => e
      user.payment_profile.errors[:stripe] << e.message
    end
  end
end
