class StripeMailer < ActionMailer::Base
  default from: 'you@example.com'

  def charge_succeeded(event)

    charge = Charge.new(user_id: User.find_by_stripe_customer_id(event.customer).id,
      charge_stripe_id: event.id,
     invoice_stripe_id: event.invoice,
        type_of_charge: event.object,
                amount: event.amount,
           description: event.description,
        date_of_charge: DateTime.strptime(event.created.to_s,'%s'),
          card_charged: nil)
    charge.save

    # @current_plan = Subscription.find_by_stripe_id(Invoice.find_by_invoice_stripe_id(event.invoice).subscription_stripe_id).plan.name
    @currency = User.find_by_stripe_customer_id(event.customer).currency
    @amount = Money.new(event.amount, @currency).format
    # @interval = Subscription.find_by_stripe_id(Invoice.find_by_invoice_stripe_id(event.invoice).subscription_stripe_id).plan.interval
    @to = User.find_by_stripe_customer_id(event.customer).email

    mail(to: @to, subject: "LightVest Charge").deliver
  end

  def charge_failed(event)
  end

  def invoice_item_created(event)

    invoice = Invoice.new(user_id: User.find_by_stripe_customer_id(event.customer).id,
                      invoice_stripe_id: event.id,
                      type_of_invoice: event.object,
                      amount: event.amount,
                      description: event.description,
                      date_of_invoice: DateTime.strptime(event.date.to_s,'%s'),
                      card_charged: nil)

    invoice.save

  end

  def invoice_created(event)

    invoice = Invoice.new(user_id: User.find_by_stripe_customer_id(event.customer).id,
                      invoice_stripe_id: event.id,
                      subscription_stripe_id: event.subscription,
                      type_of_invoice: event.object,
                      amount: event.amount_due,
                      description: event.statement_descriptor,
                      date_of_invoice: DateTime.strptime(event.date.to_s,'%s'),
                      card_charged: nil)

    invoice.save

  end

  def invoice_payment_succeeded(event)
  end

  def invoice_payment_failed(event)

  end

  def customer_subscription_deleted(event)
  end



end
