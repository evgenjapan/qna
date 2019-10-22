require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'relations' do
    it { should belong_to :question }
    it { should belong_to :user }
  end

  describe 'validations' do
    it { should validate_presence_of :body }
  end

  describe 'best!' do
    let!(:question) { create(:question) }
    let(:answer) { create(:answer, question: question) }
    let(:another_answer) { create(:answer, question: question) }

    it 'Should set answer as best' do
      answer.best!
      expect(answer).to be_best
    end

    it 'Should change answer best answer' do
      best_answer = create(:answer, :best, question: question)
      expect(answer).to_not be_best
      expect(best_answer).to be_best

      answer.best!
      best_answer.reload

      expect(answer).to be_best
      expect(best_answer).to_not be_best
    end
  end
end
