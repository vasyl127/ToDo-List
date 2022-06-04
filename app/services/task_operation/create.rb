  module TaskOperation
    class Create
      attr_reader :task

      def initialize(params)
        @task = find_user(params).tasks.new(params[:task_params])

        create_task
      end

      def create_task
        @task.save
      end

      private

      def find_user(params)
        User.find_by(telegram_id: params[:telegram_id]) || User.find_by_id(params[:current_user_id])
      end
    end
  end
