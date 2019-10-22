require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create :question, user: user }

  describe 'POST #create' do
    context 'Authenticated user' do
      before { login(user) }
      context 'with valid attributes' do
        it 'save a new question to database' do
          expect { post :create, params: { question: attributes_for(:question) } }.to change(user.questions, :count).by(1)
        end

        it 'redirects to show view' do
          post :create, params: { question: attributes_for(:question) }

          expect(response).to redirect_to assigns(:exposed_question)
        end
      end

      context 'with invalid attributes' do
        it 'does not save the question' do
          expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
        end

        it 're-renders new view' do
          post :create, params: { question: attributes_for(:question, :invalid) }

          expect(response).to render_template :new
        end
      end
    end

    context 'Unauthenticated user' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question) } }.to_not change(Question, :count)
      end

      it 'redirects to auth view' do
        delete :destroy, params: { id: question }

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PATCH #update' do
    context 'Authenticated user' do
      before { login(user) }
      context 'with valid attributes' do
        it 'changes the question attributes' do
          patch :update, params: { id: question, question: { title: 'new title', body: 'new body' }, format: :js  }
          question.reload

          expect(question.title).to eq 'new title'
          expect(question.body).to eq 'new body'
        end

        it 'redirects to updated question' do
          patch :update, params: { id: question, question: attributes_for(:question), format: :js }

          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do

        it 'does not change question' do
          title = question.title
          body = question.body

          patch :update, params: { id: question, question: attributes_for(:question, :invalid), format: :js }
          question.reload

          expect(question.title).to eq title
          expect(question.body).to eq body
        end

        it 're-renders edit view' do
          patch :update, params: { id: question, question: attributes_for(:question, :invalid), format: :js }
          expect(response).to render_template :update
        end
      end

      context 'trying to edit another user question' do
        let!(:question) { create(:question, user: create(:user)) }
        it 'does not change question' do
          title = question.title
          body = question.body

          patch :update, params: { id: question, question: attributes_for(:question), format: :js }
          question.reload

          expect(question.title).to eq title
          expect(question.body).to eq body
        end
      end
    end

    context 'Unauthenticated user' do
      it 'does not change question' do
        title = question.title
        body = question.body

        patch :update, params: { id: question, question: attributes_for(:question), format: :js }
        question.reload

        expect(question.title).to eq title
        expect(question.body).to eq body
      end

      it 'return 401 Unauthorized' do
        patch :update, params: { id: question, question: attributes_for(:question), format: :js }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'Authenticated user' do
      before { login(user) }

      context 'tries to delete his question' do
        let!(:users_question) { create(:question, user: user) }

        it 'deletes the question' do
          expect { delete :destroy, params: { id: users_question } }.to change(Question, :count).by(-1)
        end

        it 'redirects to index view' do
          delete :destroy, params: { id: users_question }

          expect(response).to redirect_to questions_path
        end
      end

      context 'tries to delete not his question' do
        let(:another_user) { create(:user) }
        let!(:question) { create :question, user: another_user }

        it 'does not delete question' do
          expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
        end

        it 'redirects to show view' do
          delete :destroy, params: { id: question }

          expect(response).to redirect_to question_path(question)
        end
      end
    end

    context 'Unauthenticated user' do
      let!(:question) { create :question }

      it 'does not delete question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

      it 'redirects to auth view' do
        delete :destroy, params: { id: question }

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

end
