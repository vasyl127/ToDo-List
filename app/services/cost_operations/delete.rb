module CostOperations
  class Delete
    attr_reader :cost, :current_user, :project, :project_name, :cost_name

    def initialize(params)
      @current_user = find_user(params[:telegram_id])
      @project_name = params[:project_name]
      @project = find_project
      @cost_name = params[:cost_name]
      @cost = find_cost
    end

    def delete_cost
      cost.destroy if cost.present?
    end

    private

    def find_cost
      project.costs.find_by(name: cost_name)
    end

    def find_project
      current_user.projects.find_by(name: project_name)
    end

    def find_user(telegram_id)
      User.find_by(telegram_id: telegram_id)
    end
  end
end
