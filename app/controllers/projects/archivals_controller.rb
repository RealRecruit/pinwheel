class Projects::ArchivalsController < ApplicationController
  include AccountScoped
  include ProjectScoped

  def create
    @project.archive

    @project.assigned_users.each do |user|
      ProjectMailer.with(project: @project, user: user).archived.deliver_later
    end

    redirect_to account_projects_path(Current.account), notice: "#{@project.name} was archived."
  end
end
