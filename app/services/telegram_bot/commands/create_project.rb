module TelegramBot
  module Commands
    class CreateProject
      include ::TelegramBot::Errors

      attr_reader :answer, :message, :telegram_id, :errors, :steps_controller, :params, :keyboard

      def initialize(params)
        @params = params
        @message = params[:message]
        @telegram_id = params[:telegram_id]
        @errors = params[:errors]
        @steps_controller = params[:steps_controller]
        @keyboard = params[:keyboard]

        exec_command
      end

      private

      def exec_command
        @answer = send(steps_controller.current_step)
        steps_controller.next_step
      end

      def fill_name
        { text: I18n.t('telegram.messages.fill_project_name') }
      end

      def save_fill_name
        params[:project_params] = { name: message }
        steps_controller.next_step

        { text: create_project, keyboard: keyboard.start_keyboard }
      end

      def create_project
        ::ProjectOperations::Create.new(params).project
        return I18n.t('telegram.messages.project_created') unless errors.any?
      end
    end
  end
end
