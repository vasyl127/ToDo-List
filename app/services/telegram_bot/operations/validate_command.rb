module TelegramBot
  module Operations
    class ValidateCommand
      TELEGRAM_COMANDS = %w[/start
                            /create_project
                            /project_list].freeze

      attr_reader :message, :errors, :validator

      def initialize(message:, errors:)
        @message = message
        @errors = errors
        @validator = command_in_list?
      end

      def command_in_list?
        TELEGRAM_COMANDS.include?(message.downcase)
      end
    end
  end
end