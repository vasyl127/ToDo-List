module CostOperations
  class Show
    attr_reader :cost, :current_user, :project, :project_name

    def initialize(telegram_id:, project_name:)
      @current_user = find_user(telegram_id)
      @project_name = project_name
      @project = find_project
    end

    def return_cost(name)
      project.costs.find_by(name: name)
    end

    def return_costs
      project.costs if project.present?
    end

    private

    def find_project
      current_user.projects.find_by(name: project_name)
    end

    def find_user(telegram_id)
      User.find_by(telegram_id: telegram_id)
    end
  end
end