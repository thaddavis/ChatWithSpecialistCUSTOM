require 'rails_helper'

RSpec.feature "Sign Up", :type => :feature do
  scenario "Create a new user without password" do
    Plan.create!(stripe_id: 'starter_plan', name: 'Starter Plan', amount: 0, interval: 'month', description: '<h4 class="text-center">Starter</h4><ul><li> FREE </li><li> Trial usage of our tools </li><li> Automated financial advice </li></ul>', published: true)
    visit "/users/sign_up"
    fill_in "Email", :with => "my@email.com"
    page.find(".btn-primary").click
    expect(page).to have_text("Password can't be blank")
  end

  scenario "Create a new user without password confirmation" do
    Plan.create!(stripe_id: 'starter_plan', name: 'Starter Plan', amount: 0, interval: 'month', description: '<h4 class="text-center">Starter</h4><ul><li> FREE </li><li> Trial usage of our tools </li><li> Automated financial advice </li></ul>', published: true)
    visit "/users/sign_up"
    fill_in "Email", :with => "my@email.com"
    fill_in "Password", :with => "asdfasdf"
    page.find(".btn-primary").click
    expect(page).to have_text("Password confirmation doesn't match Password")
  end

  scenario "Create a new user" do
    Plan.create!(stripe_id: 'starter_plan', name: 'Starter Plan', amount: 0, interval: 'month', description: '<h4 class="text-center">Starter</h4><ul><li> FREE </li><li> Trial usage of our tools </li><li> Automated financial advice </li></ul>', published: true)
    visit "/users/sign_up"
    fill_in "Email", :with => "my@email.com"
    fill_in "Password", :with => "asdfasdf"
    fill_in "Password confirmation", :with => "asdfasdf"
    page.find(".btn-primary").click

    expect(page).to have_text("A message with a confirmation link has been sent to your email address.")
  end
end
