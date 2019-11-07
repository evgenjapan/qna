class Answer < ApplicationRecord
  include ::FileConcern

  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  default_scope { order(best: :desc) }

  def best!
    transaction do
      question.answers.where(best: true).update_all(best: false)
      update!(best: true)
    end
  end

end
