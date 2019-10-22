require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create :question, user: user }

  describe 'POST #create' do
    context 'Authenticated user' do
      before { login(user) }

      context 'with valid attributes' do
        it 'save a new answer to question and user' do
          expect do
            post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
            to change(question.answers, :count).by(1)
            to change(user.answers, :count).by(1)
          end
        end

        it 'renders create view' do
          post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }

          expect(response).to render_template :create
        end
      end

      context 'with invalid attributes' do
        it 'does not save the answer' do
          expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js }.to_not change(Answer, :count)
        end

        it 'renders create view' do
          post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js }

          expect(response).to render_template :create
        end
      end
    end

    context 'Unauthenticated user' do
      it 'does not save the answer' do
        expect do
          post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js
          to_not change(Answer, :count)
        end
      end

      it 'return 401 Unauthorized' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'Authenticated user' do
      before { login(user) }

      context 'User tries to delete his answer' do
        let!(:users_answer) { create(:answer, question: question, user: user) }

        it 'deletes the answer' do
          expect do
            delete :destroy, params: { id: users_answer }, format: :js
            to change(Answer, :count).by(-1)
          end
        end

        it 'redirects to question show view' do
          delete :destroy, params: { id: users_answer, format: :js }

          expect(response).to render_template :destroy
        end
      end

      context 'User tries to delete not his answer' do
        let(:another_user) { create(:user) }
        let!(:answer) { create(:answer, question: question, user: another_user) }

        it 'does not delete answer' do
          expect { delete :destroy, params: { id: answer, format: :js } }.to_not change(Answer, :count)
        end

        it 'redirects to question show view' do
          delete :destroy, params: { id: answer, format: :js }

          expect(response).to render_template :destroy
        end
      end
    end

    context 'Unauthenticated user' do
      let!(:answer) { create(:answer) }

      it 'does not delete answer' do
        expect { delete :destroy, params: { id: answer, format: :js } }.to_not change(Answer, :count)
      end

      it 'returns 401 Unauthorized' do
        delete :destroy, params: { id: answer, format: :js }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, question: question, user: user) }
    context 'Authenticated user' do
      before { login(user) }

      context 'with valid attributes' do
        it 'changes answer attributes' do
          patch :update, params: { id: answer, answer: { body: 'edited body' }, format: :js }
          answer.reload
          expect(answer.body).to eq 'edited body'
        end

        it 'renders update view' do
          patch :update, params: { id: answer, answer: { body: 'edited body' }, format: :js }
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        it 'does not change answer attributes' do
          expect do
            patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid), format: :js }
          end.to_not change(answer, :body)
        end

        it 'renders update view' do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid), format: :js }
          expect(response).to render_template :update
        end
      end

      context 'trying to edit another user answer' do
        let!(:answer) { create(:answer, question: question, user: create(:user)) }

        it 'does not changes answer attributes' do
          patch :update, params: { id: answer, answer: { body: 'edited body' }, format: :js }
          answer.reload
          expect(answer.body).to_not eq 'edited body'
        end
      end
    end

    context 'Unauthenticated user' do
      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer), format: :js }
        end.to_not change(answer, :body)
      end

      it 'returns 401 Unauthorized' do
        patch :update, params: { id: answer, answer: attributes_for(:answer), format: :js }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST #best' do
    context 'Authenticated user' do
      context 'Question author' do
        before { login(user) }
        let!(:answer) { create(:answer, question: question) }

        it 'select answer as best' do
          post :best, params: { id: answer, format: :js }
          answer.reload
          expect(answer).to be_best
        end

        it 'render best template' do
          post :best, params: { id: answer, format: :js }
          expect(response).to render_template :best
        end
      end

      context 'Not author of the question' do
        before { login(create(:user)) }
        let!(:answer) { create(:answer, question: question, user: user) }

        it 'trying to select answer as best' do
          post :best, params: { id: answer, format: :js }
          answer.reload
          expect(answer).to_not be_best
        end

        it 'render best template' do
          post :best, params: { id: answer, format: :js }
          expect(response).to render_template :best
        end
      end
    end

    context 'Unauthenticated user' do
      let!(:answer) { create(:answer) }

      it 'doest not set answer as best' do
        post :best, params: { id: answer, format: :js }
        answer.reload
        expect(answer).to_not be_best
      end

      it 'returns 401 Unauthorized' do
        post :best, params: { id: answer, format: :js }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
