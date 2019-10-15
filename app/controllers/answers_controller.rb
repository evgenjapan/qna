class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %w(index show)
  expose :question, ->{ Question.find(params[:question_id]) }
  expose :answer, build: -> (answer_params) { question.answers.new(answer_params) }

  def create
    answer.user = current_user
    if answer.save
      redirect_to question_path(answer.question), notice: 'Successfully created.'
    else
      render 'questions/show'
    end
  end

  def destroy
    if current_user.author_of?(answer)
      answer.destroy
      message = { notice: 'Your answer succesfully deleted.' }
    else
      message = { alert: 'You are not the author of this answer.' }
    end

    redirect_to answer.question, message
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
