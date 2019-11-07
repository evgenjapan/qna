class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %w(index show)
  expose :question, ->{ Question.find(params[:question_id]) }
  expose :answer, -> { Answer.with_attached_files.find(params[:id]) }
  expose :answer, build: -> (answer_params) { question.answers.new(answer_params) }

  def create
    answer.user = current_user
    answer.save  # decent exposure gem already done answer.new
  end

  def update
    answer.update(answer_params)  if current_user&.author_of?(answer)
    @question = answer.question
  end

  def destroy
    answer.destroy if current_user.author_of?(answer)
  end

  def best
    @question = answer.question
    answer.best! if current_user.author_of?(@question)
  end

  private

  def answer_params
    params.require(:answer).permit(:body, files: [])
  end
end
