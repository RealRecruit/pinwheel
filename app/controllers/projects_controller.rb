class ProjectsController < ApplicationController
  include AccountScoped

  before_action :set_project, only: :show

  def index
    if params[:archived]
      @projects = Current.account.projects.archived.order(archived_at: :desc)
    else
      @projects = Current.account.projects.active.includes(:assignments, :comments).order(:name)
    end
  end

  def show
  end

  def new
    @project = Current.account.projects.new
  end

  def create
    @project = Current.account.projects.new(project_params)

    if @project.save
      redirect_to account_project_path(Current.account, @project), notice: "Project created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
    def set_project
      @project = Current.account.projects.find(params[:id])
    end

    def project_params
      params.expect(project: [ :name, :description ])
    end
end
