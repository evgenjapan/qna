class RemoveTitleFromAnswers < ActiveRecord::Migration[5.2]
  def change
    remove_column :answers, :title
  end
end
