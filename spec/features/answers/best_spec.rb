require 'rails_helper'

feature 'The author of the question can select one answer as best', %q(
  In order to mark the correct answer
  Only author of question can select bet answer
) do

  given!(:user) { create(:user) }
  given!(:second_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 2, question: question, user: create(:user)) }

  describe "Any user", js: true do
    given!(:best_answer) { create(:answer, :best, question: question) }

    before do
      visit(question_path(question))
    end

    scenario 'sees best answer first' do
      within "#answer_#{question.answers.first.id}" do
        expect(page).to have_content question.answers.where(best: true).first.body
        expect(page).to_not have_link 'Select as best'
      end
    end
  end

  describe 'Authenticated user', js: true do
    given!(:other_question) { create(:question, user: create(:user)) }

    before do
      sign_in(user)
      visit(question_path(question))
    end

    scenario 'select one answer as best' do
      within "#answer_#{answers.first.id}" do
        click_on 'Select as best'

        expect(page).to have_content answers.first.body
        expect(page).to_not have_link 'Select as best'
      end
    end

    scenario 'select another answer as the best' do
      within "#answer_#{answers.last.id}" do
        click_on 'Select as best'

        expect(page).to have_content answers.last.body
        expect(page).to_not have_link 'Select as best'
      end
    end
  end

  scenario 'trying to select best answer for another users question' do
    sign_in(second_user)
    visit(question_path(question))

    within "#answer_#{answers.first.id}" do
      expect(page).to_not have_link 'Select as best'
    end
  end

  scenario 'Unauthenticated user can not select best answer' do
    visit(question_path(question))

    expect(page).to_not have_link 'Select as best'
  end

end