# frozen_string_literal: true

module TelegramBot
  module Commands
    class LanguageSet
      include ::TelegramBot::Errors

      attr_reader :answer, :message, :telegram_id, :errors, :steps_controller, :params, :keyboard

      def initialize(params)
        @params = params
        @message = params[:message]
        @telegram_id = params[:user_telegram_id]
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

      def language_list
        { text: "#{I18n.t('telegram.messages.chose_language')}: #{current_language}",
          keyboard: keyboard.language_keyboard }
      end

      def language_set
        set_language if message == keyboard.secondary_keys[:language_ua] || keyboard.secondary_keys[:language_en]
        steps_controller.default_steps
        { text: "#{current_language} #{I18n.t('telegram.messages.language_set')}", keyboard: keyboard.start_keyboard }
      end

      def set_language
        return update_locale('ua') if message == keyboard.secondary_keys[:language_ua]

        update_locale('en')
      end

      def update_locale(value)
        current_user.update(locale: value)
      end

      def current_language
        value = "language_#{current_user.locale}".to_sym
        keyboard.secondary_keys[value]
      end

      def current_user
        User.find_by(telegram_id: telegram_id)
      end
    end
  end
end
