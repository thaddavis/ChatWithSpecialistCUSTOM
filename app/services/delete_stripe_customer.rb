class DeleteStripeCustomer
  def self.call(user)
    begin
      (customer_id = user.stripe_customer_id) if user
      if customer_id
        c = Stripe::Customer.retrieve(customer_id)
        c.delete
      end

      return true
    rescue Stripe::StripeError => e
      return false
    end
  end
end
