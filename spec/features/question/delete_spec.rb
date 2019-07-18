require 'rails_helper'

feature 'Author can delete his question' do

  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: author) }

  describe 'Authenticated user' do
    scenario 'deletes his question' do
      sign_in(author)
      visit question_path(question)

      expect(page).to have_content question.body

      click_on 'Delete'

      expect(page).to have_content 'Your question succesfully deleted.'
      expect(page).to_not have_content question.body
    end

    scenario "deletes someone else's question" do
      sign_in(user)
      visit question_path(question)

      expect(page).to_not have_link 'Delete'
    end
  end

  describe 'Unauthenticated user' do
    scenario 'tries to deletes a question' do
      visit question_path(question)

      expect(page).to_not have_link 'Delete'
    end
  end
end
