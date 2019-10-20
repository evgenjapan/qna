require 'rails_helper'

feature 'Author can delete his answer' do

  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, question: question, user: author) }

  describe 'Authenticated user' do
    scenario 'deletes his answer', js: true do
      sign_in(author)
      visit question_path(question)

      expect(page).to have_content answer.body

      click_on 'Delete answer'

      expect(page).to have_content 'Your answer succesfully deleted.'
      expect(page).to_not have_content answer.body
    end

    scenario "deletes someone else's answer", js: true do
      sign_in(user)
      visit question_path(question)

      expect(page).to_not have_link 'Delete answer'
    end
  end

  describe 'Unauthenticated user' do
    scenario 'tries to deletes an answer', js: true do
      visit question_path(question)

      expect(page).to_not have_link 'Delete answer'
    end
  end
end
