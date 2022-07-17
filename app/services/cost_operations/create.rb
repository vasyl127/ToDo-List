module CostOperations
  class Create
    attr_reader :cost, :current_user, :project, :project_name, :user_telegram_id

    def initialize(params)
      @current_user = find_user(params)
      @user_telegram_id = params[:user_telegram_id]
      @project_name = params[:store_params].store.dig(user_telegram_id, :project_name)
      @project = find_project
      @cost = project.costs.create(params[:cost_params])
    end

    private

    def find_project
      current_user.projects.find_by(name: project_name)
    end

    def find_user(params)
      User.find_by(telegram_id: params[:user_telegram_id]) || User.find_by_id(params[:current_user_id])
    end
  end
end
