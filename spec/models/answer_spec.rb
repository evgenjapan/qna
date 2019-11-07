require 'rails_helper'

RSpec.describe Answer, type: :model do
  include_examples 'many attached files', Question

  describe 'relations' do
    it { should belong_to :question }
    it { should belong_to :user }
  end

  describe 'validations' do
    it { should validate_presence_of :body }
  end

  describe 'scopes' do
    let!(:best_answers) { create_list(:answer, 5, :best) }
    let!(:answers) { create_list(:answer, 15) }

    it "applies a default scope to collections by best descending" do
      expect(Answer.all).to eq Answer.all.order(best: :desc)
    end
  end

  describe 'best!' do
    let!(:question) { create(:question) }
    let(:answer) { create(:answer, question: question) }
    let(:another_answer) { create(:answer, question: question) }

    it 'Should set answer as best' do
      answer.best!
      expect(answer).to be_best
    end

    let!(:best_answer) { create(:answer, :best, question: question) }

    it 'Should change answer best answer' do
      expect(answer).to_not be_best
      expect(best_answer).to be_best

      answer.best!
      best_answer.reload

      expect(answer).to be_best
      expect(best_answer).to_not be_best
    end
  end
end
