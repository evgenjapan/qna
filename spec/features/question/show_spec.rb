require 'rails_helper'

feature 'User can view question and create answers for it', %q{
  User can view question and answers for it on the same page
  Authenticated user can create answer for question on question detail page
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 5, question: question, user: user) }

  scenario 'User tries to view answers for question' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content 'Answers'

    answers.each { |answer| expect(page).to have_content answer.body }
  end
end
