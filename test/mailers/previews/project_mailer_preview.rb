class ProjectMailerPreview < ActionMailer::Preview
  def archived
    project = Project.archived.first
    ProjectMailer.with(project: project, user: project.assigned_users.first || project.creator).archived
  end
end
