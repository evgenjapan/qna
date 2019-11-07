class Question < ApplicationRecord
  include ::FileConcern

  has_many :answers, dependent: :destroy
  belongs_to :user

  validates :title, :body, presence: true
end
