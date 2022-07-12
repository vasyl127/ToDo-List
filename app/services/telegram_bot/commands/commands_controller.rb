module TelegramBot
  module Commands
    class CommandsController
      include ::TelegramBot::Errors

      attr_reader :message, :errors, :answer, :steps_controller, :current_user, :params, :keyboard

      def initialize(params)
        @params = params
        @message = params[:message]
        @errors = params[:errors]
        @steps_controller = params[:steps_controller]
        @user_telegram_id = params[:user_telegram_id]
        @keyboard = params[:keyboard]

        validate_comand
      end

      def validate_comand
        # return exec_command if command_valid?

        # errors.add_errors invalid_commands
        exec_command
      end

      private

      def exec_command
        @answer = if it_is_command? || message == '/start'
                    send normalize_command
                  else
                    send steps_controller.steps_list_name.downcase
                  end
      end

      def home
        start
      end

      def start
        steps_controller.default_steps if it_is_command? || message == '/start'
        ::TelegramBot::Commands::Start.new(params).answer
      end

      def create_project
        steps_controller.start_create_project if it_is_command?
        ::TelegramBot::Commands::CreateProject.new(params).answer
      end

      def create_cost
        steps_controller.start_create_cost if it_is_command?
        ::TelegramBot::Commands::CreateCost.new(params).answer
      end

      def projects_list
        steps_controller.start_projects_list if it_is_command?
        ::TelegramBot::Commands::ProjectList.new(params).answer
      end

      def delete_project
        start
      end

      def share_project
        start
      end

      def it_is_command?
        keyboard.keys.values.include? message
      end

      def normalize_command
        return message.delete('/') if message == '/start'

        keyboard.keys.key(message)
      end
    end
  end
end
