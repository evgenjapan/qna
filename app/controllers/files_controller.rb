class FilesController < ApplicationController
  before_action :authenticate_user!
  expose :file, -> { ActiveStorage::Attachment.find(params[:id]) }

  def destroy
    file.purge if current_user.author_of?(file.record)
  end
end
