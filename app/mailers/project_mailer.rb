class ProjectMailer < ApplicationMailer
  before_action { @project, @user = params[:project], params[:user] }

  def archived
    mail to: @user.email_address, subject: "#{@project.name} was archived"
  end
end
