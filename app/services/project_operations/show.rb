# frozen_string_literal: true

module ProjectOperations
  class Show
    attr_reader :project, :current_user

    def initialize(params)
      @current_user = find_user(params)
    end

    def return_project(name)
      current_user.projects.find_by(name: name)
    end

    def return_projects
      current_user.projects
    end

    private

    def find_user(params)
      User.find_by(telegram_id: params[:telegram_id]) || User.find_by_id(params[:current_user_id])
    end
  end
end
