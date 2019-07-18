require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'relations' do
    it { should have_many(:answers).dependent(:destroy) }
    it { should have_many(:questions).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
  end

  describe 'author_of?' do
    let(:author) { create(:user) }
    let(:user) { create(:user) }
    let(:question) { create(:question, user: author) }
    let(:answer) { create(:answer, question: question, user: author) }

    it 'Return true if user equals to question.user' do
      expect(author.author_of?(question)).to be_truthy
    end

    it 'Return true if user equals to answer.user' do
      expect(author.author_of?(answer)).to be_truthy
    end

    it 'Return false if user not equals to question.user' do
      expect(user.author_of?(question)).to be_falsey
    end

    it 'Return false if user not equals to answer.user' do
      expect(user.author_of?(answer)).to be_falsey
    end

    it 'Return nil if instance has no user attribute' do
      expect(user.author_of?(author)).to eq nil
    end
  end
end
