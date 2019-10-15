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
    let(:instance) { create(:question, user: author) }

    it 'Return true if user equals to instance.user' do
      expect(author).to be_author_of(instance)
    end

    it 'Return false if user not equals to instance.user' do
      expect(user).to_not be_author_of(instance)
    end

    it 'Return false if instance has no user attribute' do
      expect(user).to_not  be_author_of(Object.new)
    end
  end
end
