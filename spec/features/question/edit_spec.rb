require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like to be able to edit my question
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:seconds_user_question) { create(:question, user: create(:user)) }

  scenario 'Unauthenticated user can not edit question' do
    visit question_path(question)

    expect(page).to_not have_link('Edit question')
  end

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'edits his question', js: true do
      click_on 'Edit question'
      within '.question' do
        fill_in 'Question title', with: 'edited title'
        fill_in 'Your question', with: 'edited body'
        click_on 'Save'

        expect(page).to_not have_content(question.body)
        expect(page).to_not have_content(question.title)
        expect(page).to have_content('edited title')
        expect(page).to have_content('edited body')
        expect(page).to_not have_selector('textarea')
        expect(page).to_not have_selector('input[type="text"]')
      end
    end

    scenario 'edits his question with errors', js: true do
      click_on 'Edit question'

      fill_in "Your question", with: ''
      click_on 'Save'

      expect(page).to have_content(question.body)
      expect(page).to have_content("Body can't be blank")
    end

    scenario 'tries to edit other users question' do
      visit question_path(seconds_user_question)

      expect(page).to_not have_link('Edit question')
    end
  end
end
