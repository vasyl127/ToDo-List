# frozen_string_literal: true

module TaskOperations
  class Create
    attr_reader :task

    def initialize(params)
      @task = find_user(params).tasks.create(params[:task_params])
    end

    private

    def find_user(params)
      User.find_by(telegram_id: params[:user_telegram_id]) || User.find_by_id(params[:current_user_id])
    end
  end
end
