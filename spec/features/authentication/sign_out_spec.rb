require 'rails_helper'

feature 'User can sign out', %q{
  In order to close session
  User would like to sign out
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user tries to sign out' do
    sign_in(user)
    visit '/'
    click_on 'Log out'

    expect(page).to have_content 'Signed out successfully.'
  end

  scenario 'Unauthenticated user tries to sign out' do
    visit '/'

    expect(page).to_not have_link 'Log out'
  end

end
