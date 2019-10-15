require 'rails_helper'

feature 'User can create answers for question', %q{
  Authenticated user can create answer for question on question detail page
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'creates answer' do
      fill_in 'Body', with: 'test answer 123'
      click_on 'Create answer'

      expect(page).to have_content 'Successfully created.'
      expect(page).to have_content 'test answer 123'
    end

    scenario 'creates answer with errors' do
      click_on 'Create answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tris to create answer' do
    visit question_path(question)

    click_on 'Create answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end