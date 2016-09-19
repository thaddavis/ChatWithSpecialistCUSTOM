require 'rails_helper'

RSpec.feature "Sign Up", :type => :feature do
  scenario "change username" do
    Plan.create!(stripe_id: 'starter_plan', name: 'Starter Plan', amount: 0, interval: 'month', description: '<h4 class="text-center">Starter</h4><ul><li> FREE </li><li> Trial usage of our tools </li><li> Automated financial advice </li></ul>', published: true)
    u = FactoryGirl.create(:user)
    expect(u).to be_valid

    login_as u
    visit user_path(u)

    fill_in "Username", :with => "asdfasdf"
    click_button "Update User"

    expect(page).to have_text("User updated")
  end
end


