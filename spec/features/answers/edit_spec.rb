require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:file) { fixture_file_upload("#{Rails.root}/spec/rails_helper.rb", 'text/plain') }
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

    context 'attachments' do
      background do
        click_on 'Edit answer'

        within '.answers' do
          attach_file 'File', [
              "#{Rails.root}/spec/rails_helper.rb",
              "#{Rails.root}/spec/spec_helper.rb"
          ]

          click_on 'Save'
        end
      end

      scenario 'adds an attachment when editing his answer', js: true do
        expect(page).to have_link 'rails_helper'
        expect(page).to have_link 'spec_helper'
      end

      scenario 'deletes attachment', js: true do
        within '.answers' do
          first('.attachment').click_on 'Delete file'
          expect(page).to_not have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
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

    scenario 'tries to delete attachment for other users answers' do
      within "#answer_#{another_users_answer.id}" do
        expect(page).to_not have_link("Delete file")
      end
    end
  end
end

