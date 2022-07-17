# frozen_string_literal: true

module TelegramBot
  module Commands
    class Start
      include ::TelegramBot::Errors

      attr_reader :errors, :user_telegram_id, :keyboard, :steps_controller, :message, :answer

      def initialize(params)
        @errors = params[:errors]
        @message = params[:message]
        @steps_controller = params[:steps_controller]
        @user_telegram_id = params[:user_telegram_id]
        @keyboard = params[:keyboard]

        exec_command
      end

      private

      def exec_command
        @answer = send(steps_controller.current_step)
        steps_controller.next_step
      end

      def home_screen
        { text: I18n.t('telegram.messages.home'),
          keyboard: keyboard.start_keyboard }
      end
    end
  end
end
