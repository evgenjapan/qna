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
      fill_in 'Body', with: 'Answer for a question'
      click_on 'Answer a question'

      expect(page).to have_content 'Successfully created.'
      expect(page).to have_content 'Answer for a question'
    end

    scenario 'creates answer with errors' do
      click_on 'Answer a question'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tris to create answer' do
    visit question_path(question)

    click_on 'Answer a question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end