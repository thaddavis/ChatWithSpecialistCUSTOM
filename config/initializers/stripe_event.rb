# StripeEvent.event_retriever = lambda do |params|
#   return nil if StripeWebhook.exists?(stripe_id: params[:id])
#   StripeWebhook.create!(stripe_id: params[:id])
#   Stripe::Event.retrieve(params[:id])
# end

StripeEvent.event_retriever = lambda do |params|
    if params[:livemode]
        ::Stripe::Event.retrieve(params[:id])
    elsif Rails.env.development?
        # This will return an event as is from the request (security concern in production)
    ::Stripe::Event.construct_from(params.deep_symbolize_keys)
    else
        nil
    end
end


StripeEvent.configure do |events|

  events.subscribe 'charge.succeeded' do |event|
    StripeMailer.charge_succeeded(event.data.object).deliver
  end

  events.subscribe 'charge.failed' do |event|

  end

  events.subscribe 'invoice.created' do |event|
    StripeMailer.invoice_created(event.data.object).deliver
  end

  events.subscribe 'invoiceitem.created'  do |event|
    StripeMailer.invoice_item_created(event.data.object).deliver
  end

  events.subscribe 'invoice.payment_succeeded' do |event|

  end

  events.subscribe 'invoice.payment_failed' do |event|
  end

  events.subscribe 'customer.subscription.deleted' do |event|
  end

  events.all do |event|
    log = Logger.new( 'StripeEventLogs/StripeEventLogLIGHTVEST' + Time.now.strftime("%Y-%m-%d%H%M%S") + '.txt' )

    log.debug event
  end

end
