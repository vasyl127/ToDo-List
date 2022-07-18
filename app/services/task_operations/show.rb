# frozen_string_literal: true

module TaskOperations
  class Show
    attr_reader :current_user

    def initialize(params)
      @current_user = find_user(params)
    end

    def return_task(name)
      current_user.tasks.find_by(name: name) if current_user.present?
    end

    def return_tasks
      current_user.tasks if current_user.present?
    end

    private

    def find_user(params)
      User.find_by(telegram_id: params[:user_telegram_id]) || User.find_by_id(params[:current_user_id])
    end
  end
end
