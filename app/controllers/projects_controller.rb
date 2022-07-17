# frozen_string_literal: true

class ProjectsController < ApplicationController
  def index
    @projects = current_user.projects.all
  end
end
