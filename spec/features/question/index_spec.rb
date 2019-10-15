require 'rails_helper'

feature 'User can view question list', %q{
  User can view list of all questions
  In order to find required question
} do
  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 5, user: user) }

  background { visit questions_path }

  scenario 'User view question list' do
    questions.each do |question|
      expect(page).to have_content question.title
    end
  end
end
