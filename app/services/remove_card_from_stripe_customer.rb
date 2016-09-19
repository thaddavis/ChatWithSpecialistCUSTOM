class RemoveCardFromStripeCustomer
  def self.call(user, stripe_customer, fingerprint)
    begin
      card_id = nil
      stripe_customer.sources.each do |c|
        if c.fingerprint == fingerprint
          card_id = c.id
        end
      end

      if card_id
        stripe_customer.sources.retrieve(card_id).delete()
        stripe_customer.save
      end
    rescue Stripe::StripeError => e
      user.payment_profile.errors[:stripe] << e.message
    end
  end
end
