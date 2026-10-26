class CommentsController < ApplicationController
  include AccountScoped
  include ProjectScoped

  def create
    @comment = @project.comments.new(comment_params)

    if @comment.save
      redirect_to account_project_path(Current.account, @project, anchor: helpers.dom_id(@comment))
    else
      render "projects/show", status: :unprocessable_entity
    end
  end

  private
    def comment_params
      params.expect(comment: [ :body ])
    end
end
