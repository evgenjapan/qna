require 'rails_helper'

feature 'User can sign out', %q{
  In order to close session
  User would like to sign out
} do

  scenario 'User tries to sign out' do #By default unauthorized user see the same message as authorized
    visit '/'
    click_on 'Log out'

    expect(page).to have_content 'Signed out successfully.'
  end

end
