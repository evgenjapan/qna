require 'rails_helper'

RSpec.shared_examples 'many attached files' do |model_class|
  it 'have many attached file' do
    expect(model_class.new.files).to be_an_instance_of ActiveStorage::Attached::Many
  end
end
