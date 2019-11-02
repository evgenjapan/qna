require 'rails_helper'

RSpec.describe FilesController, type: :controller do
  describe 'DELETE #destroy' do
    let!(:user) { create(:user) }
    let!(:file) { fixture_file_upload("#{Rails.root}/spec/rails_helper.rb", 'text/plain') }

    context 'Authenticated user' do
      before { login user }

      context 'resource owner' do
        let!(:resource) { create(:question, user: user, files: [file]) }

        it 'removes attachments' do
          expect do
            delete :destroy, params: { id: resource.files.first }, format: :js
            to change(resource.files, :count).by(-1)
          end
        end

        it 'renders destroy view' do
          delete :destroy, params: { id: resource.files.first }, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'not resource owner' do
        let!(:resource) { create(:question, user: create(:user), files: [file]) }

        it 'can not remove attachment' do
          expect { delete :destroy, params: { id: resource.files.first }, format: :js }.to_not change(resource.files, :count)
        end

        it 'renders destroy view' do
          delete :destroy, params: { id: resource.files.first }, format: :js
          expect(response).to render_template :destroy
        end
      end
    end

    context 'Unauthenticated user' do
      let!(:resource) { create(:question, user: user, files: [file]) }

      it 'does not removes attachment' do
        expect do
          delete :destroy, params: { id: resource.files.first }, format: :js
          to_not change(resource.files, :count)
        end
      end

      it 'returns 401 Unauthorized' do
        delete :destroy, params: { id: resource.files.first }, format: :js
        expect(response).to have_http_status(401)
      end
    end
  end
end
