require 'rails_helper'

feature 'User can sign up', %q{
  In order to been able to authorize
  User would like to sign up
} do

  background { visit new_user_registration_path }

  scenario 'User sign up with valid data' do
    user_attributes = attributes_for(:user)
    fill_in 'Email', with: user_attributes[:email]
    fill_in 'Password', with: user_attributes[:password]
    fill_in 'Password confirmation', with: user_attributes[:password_confirmation]

    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'User sign up with invalid data' do
    click_on 'Sign up'

    expect(page).to have_content "Email can't be blank"
  end
end
