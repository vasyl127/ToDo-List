# frozen_string_literal: true

module ProjectOperations
  class Create
    attr_reader :project, :current_user, :errors, :project_params

    def initialize(params)
      @current_user = find_user(params)
      @errors = params[:errors]
      @project_params = params[:project_params]

      create_project
    end

    private

    def create_project
      @project = if project_uniq?
                   created_project
                 else
                   errors.all_errors_messages
                 end
    end

    def project_uniq?
      return true if current_user.projects.where(project_params).blank?

      errors.add_errors I18n.t('telegram.errors.project_uniq')
      false
    end

    def created_project
      value = current_user.projects.create(project_params)
      errors.add_errors(value.errors.full_messages) if value.errors.any?

      value
    end

    def find_user(params)
      User.find_by(telegram_id: params[:user_telegram_id]) || User.find_by_id(params[:current_user_id])
    end
  end
end
