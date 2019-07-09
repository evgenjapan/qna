class AnswersController < ApplicationController
  expose :question, ->{ Question.find(params[:question_id]) }
  expose :answer

  def create
    answer = question.answers.new(answer_params)
    if answer.save
      redirect_to question_answers_path(question)
    else
      render :new
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:title, :body)
  end
end
