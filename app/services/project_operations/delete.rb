module ProjectOperations
  class Delete
    attr_reader :current_user, :project_name

    def initialize(params)
      @current_user = find_user(params)
      @project_name = params[:project_name]
    end

    def delete_project
      project = current_user.projects.find_by(name: project_name)

      project.destroy if project.present?
    end

    private

    def find_user(params)
      User.find_by(telegram_id: params[:telegram_id]) || User.find_by_id(params[:current_user_id])
    end
  end
end
