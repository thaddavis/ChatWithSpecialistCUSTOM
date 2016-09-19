class PaymentProfilesController < ApplicationController

  after_action :verify_authorized
  before_action :set_payment_profile, only: [:show, :edit, :switch_plan, :add_card, :remove_card, :set_default_card]

  def show

    @charges = []
    @invoices = []

    authorize @payment_profile

    customer = FetchStripeCustomer.call(@payment_profile.user)
    if @payment_profile.user.payment_profile.errors.any?
      render 'show'
      return
    end

    Charge.where(:user_id => current_user.id).each do |c|
      stripe_charge = FetchStripeCharge.call(@payment_profile.user, c.charge_stripe_id)
      if @payment_profile.user.payment_profile.errors.any?
        render 'show'
        return
      end
      @charges << stripe_charge
    end

    Invoice.where(:user_id => current_user.id).each do |c|
      stripe_invoice = FetchStripeInvoice.call(@payment_profile.user, c.invoice_stripe_id)
      if @payment_profile.user.payment_profile.errors.any?
        render 'show'
        return
      end
      @invoices << stripe_invoice
    end

    @invoices = @invoices.compact


  end

  def edit
    authorize @payment_profile

    customer = FetchStripeCustomer.call(@payment_profile.user)
    if @payment_profile.user.payment_profile.errors.any?
      render 'edit'
      return
    end

    # Sync Plan With Stripe
    customer.subscriptions.each do |s|
      sub = current_user.subscriptions.find_by_stripe_id(s.id)
      plan = Plan.find_by_stripe_id(s.plan.id)
      if !sub
        subscription = Subscription.new(plan_id: plan.id, user_id: current_user.id, stripe_id: s.id)
        subscription.save!
      else
        sub.plan_id = plan.id
        sub.save!
      end
    end
    # Sync Plan With Stripe

    @cards = []

    @default_card = customer.default_source
    @cards = customer.sources
  end

  def switch_plan
    authorize @payment_profile

    stripe_customer = FetchStripeCustomer.call(@payment_profile.user)
    if @payment_profile.user.payment_profile.errors.any?
      render 'edit'
      return
    end
    ChangePlan.call(@payment_profile.user, stripe_customer, params[:stripe_subscription_id], params[:from_plan], params[:plan_id])
    if @payment_profile.user.payment_profile.errors.any?
      render 'edit'
      return
    end
    subscription = current_user.subscriptions.find_by_stripe_id(params[:stripe_subscription_id])
    if subscription
      subscription.plan = Plan.find_by_stripe_id(params[:plan_id])
      subscription.save!
    end
    redirect_to edit_payment_profile_path(current_user.payment_profile.id)
  end

  def add_card
    authorize @payment_profile

    stripe_customer = FetchStripeCustomer.call(@payment_profile.user)
    if @payment_profile.user.payment_profile.errors.any?
      render 'edit'
      return
    end

    AddCardToStripeCustomer.call(@payment_profile.user, stripe_customer, payment_profile_params[:stripeToken])
    if @payment_profile.user.payment_profile.errors.any?
      render 'edit'
      return
    end

    flash[:notice] = 'Successfully added card.'

    redirect_to edit_payment_profile_path(current_user.payment_profile.id)
  end

  def remove_card
    authorize @payment_profile

    stripe_customer = FetchStripeCustomer.call(@payment_profile.user)
    if @payment_profile.user.payment_profile.errors.any?
      render 'edit'
      return
    end

    RemoveCardFromStripeCustomer.call(@payment_profile.user, stripe_customer, params[:fingerprint])
    if @payment_profile.user.payment_profile.errors.any?
      render 'edit'
      return
    end

    if stripe_customer.sources.count == 0
      NoCardsSoDowngradeToFreePlans.call(@payment_profile.user, stripe_customer)
      if @payment_profile.user.payment_profile.errors.any?
        render 'edit'
        return
      end
      current_user.subscriptions.each do |s|
        if s
          s.plan = Plan.find_by_stripe_id('starter_plan')
          s.save!
        end
      end
    end

    flash[:notice] = 'Successfully deleted card.'

    redirect_to edit_payment_profile_path(current_user.payment_profile.id)
  end

  def set_default_card
    authorize @payment_profile

    stripe_customer = FetchStripeCustomer.call(@payment_profile.user)
    if @payment_profile.user.payment_profile.errors.any?
      render 'edit'
      return
    end

    SetDefaultCardForStripeCustomer.call(@payment_profile.user, stripe_customer, params[:fingerprint])
    if @payment_profile.user.payment_profile.errors.any?
      render 'edit'
      return
    end

    flash[:notice] = 'Successfully set card as default.'
    redirect_to edit_payment_profile_path(current_user.payment_profile.id)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment_profile
      @payment_profile = PaymentProfile.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def payment_profile_params
      # params.fetch(:payment_profile, {})
      params.permit(:stripeToken)
    end
end
