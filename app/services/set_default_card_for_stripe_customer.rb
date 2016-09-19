class SetDefaultCardForStripeCustomer
  def self.call(user, stripe_customer, fingerprint)
    begin
      card_id = nil
      stripe_customer.sources.each do |c|
        if c.fingerprint == fingerprint
          card_id = c.id
        end
      end

      if card_id
        stripe_customer.default_source = card_id
        stripe_customer.save
      end

    rescue Stripe::StripeError => e
      user.payment_profile.errors[:stripe] << e.message
    end
  end
end
