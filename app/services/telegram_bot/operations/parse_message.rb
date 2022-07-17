# frozen_string_literal: true

module TelegramBot
  module Operations
    class ParseMessage
      include ::TelegramBot::Errors

      attr_reader :message, :errors, :answer, :steps_controller, :current_user, :params

      def initialize(params)
        @params = params
        @message = params[:message]
        @errors = params[:errors]
        @steps_controller = params[:steps_controller]
        @current_user = params[:current_user]

        @answer = check_message
      end

      private

      def check_message
        ::TelegramBot::Commands::CommandsController.new(params).answer
        # return ::TelegramBot::Commands::CommandsController.new(params).answer if it_is_command?

        # method_name = steps_controller.steps_list_name.downcase
        # send(method_name)
      end
    end
  end
end
