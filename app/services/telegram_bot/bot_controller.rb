# frozen_string_literal: true

module TelegramBot
  class BotController
    attr_reader :answer, :message, :errors, :params, :current_user, :steps_controller, :keyboard, :store_params

    def initialize(message:, store_params:)
      @message = message
      @current_user = authentication
      localization
      @store_params = store_params
      @errors = ::TelegramBot::ErrorsController.new
      @steps_controller = ::TelegramBot::StepsController.new(current_user)
      @keyboard = ::TelegramBot::KeyboardsController.new
      @params = prepare_params
    end

    def return_answer
      message_proces
      return something_wrong_errors if answer.blank?
      return { text: errors.all_errors_messages, keyboard: keyboard.start_keyboard } if errors.any?

      answer
    end

    private

    def message_proces
      return something_wrong_errors unless current_user.present?

      @answer = parse_message
    end

    def prepare_params
      { message: message.text,
        errors: errors,
        user_telegram_id: current_user.telegram_id,
        steps_controller: steps_controller,
        keyboard: keyboard,
        store_params: store_params }
    end

    def something_wrong_errors
      errors.add_errors I18n.t('telegram.messages.something')
    end

    def parse_message
      ::TelegramBot::Operations::ParseMessage.new(params).answer
    end

    def authentication
      user = User.find_by(telegram_id: message.chat.id)
      return user if user.present?

      User.create(user_parmas)
    end

    def user_parmas
      name = message.chat.first_name || message.chat.last_name
      { email: "#{name}@def_telegram",
        name: name,
        password: name,
        locale: message.from.language_code,
        telegram_id: message.chat.id }
    end

    def localization
      return I18n.default_locale if authentication.locale.nil?
      return I18n.default_locale unless authentication.locale == 'ua'

      I18n.locale = :ua
    end
  end
end
