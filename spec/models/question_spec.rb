require 'rails_helper'

RSpec.describe Question, type: :model do
  include_examples 'many attached files', Question

  describe 'relations' do
    it { should have_many(:answers).dependent(:destroy) }
    it { should belong_to :user }
  end

  describe 'validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }
  end
end
