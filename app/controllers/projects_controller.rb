class ProjectsController < ApplicationController
  def index
    @projects = current_user.projects.all
  end
end
