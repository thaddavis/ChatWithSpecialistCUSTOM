class FetchStripeCharge
  def self.call(user, charge_id)
    begin
      charge = Stripe::Charge.retrieve(charge_id)
      charge
    rescue Stripe::StripeError => e
      user.payment_profile.errors[:stripe] << e.message
    end
  end
end
