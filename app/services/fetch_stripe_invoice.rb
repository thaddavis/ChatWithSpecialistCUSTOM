class FetchStripeInvoice
  def self.call(user, invoice_id)
    if invoice_id.start_with?('in')
    # invoice
      begin
        invoice = Stripe::Invoice.retrieve(invoice_id)
        invoice
      rescue Stripe::StripeError => e
        user.payment_profile.errors[:stripe] << e.message
      end
    end
    # invoice item
    # else
    #   begin
    #     invoice = Stripe::InvoiceItem.retrieve(invoice_id)
    #     invoice
    #   rescue Stripe::StripeError => e
    #     user.payment_profile.errors[:stripe] << e.message
    #   end
    # end
  end
end
