class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %w(index show)
  expose :questions, ->{ Question.all }
  expose :question, build: -> (question_params){ current_user.questions.new(question_params) }
  expose :answer, ->{question.answers.new}

  def create
    if question.save
      redirect_to question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    if question.update(question_params)
      redirect_to question
    else
      render :edit
    end
  end

  def destroy
    if current_user.author_of?(question)
      question.destroy
      redirect_to questions_path, notice: 'Your question succesfully deleted.'
    else
      redirect_to question, alert: 'You are not the author of this question.'
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
