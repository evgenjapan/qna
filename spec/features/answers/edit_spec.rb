require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:another_users_answer) { create(:answer, question: question, user: create(:user)) }

  scenario 'Unauthenticated user can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit answer'
  end
  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'edits his answer', js: true do
      click_on 'Edit answer'

      within '.answers' do
        fill_in 'Your answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content(answer.body)
        expect(page).to have_content('edited answer')
        expect(page).to_not have_selector('textarea')
        expect(page).to_not have_selector('input')
      end
    end

    scenario 'adds an attachment when editing his answer', js: true do
      click_on 'Edit answer'

      within '.answers' do
        attach_file 'File', [
            "#{Rails.root}/spec/rails_helper.rb",
            "#{Rails.root}/spec/spec_helper.rb"
        ]

        click_on 'Save'

        expect(page).to have_link 'rails_helper'
        expect(page).to have_link 'spec_helper'
      end
    end

    scenario 'add an attachment without replacing already attached files', js: true do
      click_on 'Edit answer'
      within '.answers' do
        attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"

        click_on 'Save'

        expect(page).to have_link 'rails_helper'

        click_on 'Edit answer'

        attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"

        click_on 'Save'

        expect(page).to have_link 'spec_helper'
        expect(page).to have_link 'rails_helper'
      end
    end

    scenario 'edits his answer with errors', js: true do
      click_on 'Edit answer'

      within '.answers' do
        fill_in "Your answer", with: ''
        click_on 'Save'

        expect(page).to have_content(answer.body)
        expect(page).to have_content("Body can't be blank")
      end
    end

    scenario 'tries to edit other users answers' do
      within "#answer_#{another_users_answer.id}" do
        expect(page).to_not have_link("Edit answer")
      end
    end
  end
end

