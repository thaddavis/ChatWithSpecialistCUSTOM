require "rails_helper"
require 'stripe_mock'

RSpec.describe "Add a card", :type => :request do
  it "adds a card" do
    Plan.create!(stripe_id: 'starter_plan', name: 'Starter Plan', amount: 0, interval: 'month', description: '<h4 class="text-center">Starter</h4><ul><li> FREE </li><li> Trial usage of our tools </li><li> Automated financial advice </li></ul>', published: true)
    u = FactoryGirl.create(:user)
    expect(u).to be_valid

    login_as u

    stripe_helper = StripeMock.create_test_helper

    stripeToken = stripe_helper.generate_card_token(number: '4242424242424242',
        exp_month: 12,
        exp_year: 2016,
        cvc: '123')

    post add_card_path(u), :params => { :stripeToken => stripeToken }
    follow_redirect!
    expect(response.body).to include("Successfully added card.")
  end
end


# it "creates a Widget and redirects to the Widget's page" do
#     get "/widgets/new"
#     expect(response).to render_template(:new)

#     post "/widgets", :widget => {:name => "My Widget"}

#     expect(response).to redirect_to(assigns(:widget))
#     follow_redirect!

#     expect(response).to render_template(:show)
#     expect(response.body).to include("Widget was successfully created.")
#   end
