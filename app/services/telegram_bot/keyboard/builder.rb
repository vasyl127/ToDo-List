# frozen_string_literal: true

module TelegramBot
  module Keyboard
    class Builder
      def generate_inline_buttons(buttons)
        kb = []
        buttons.each do |button|
          kb << Telegram::Bot::Types::InlineKeyboardButton.new(text: button, callback_data: 'button')
        end

        Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
      end

      def generate_bottom_buttons(buttons)
        Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: buttons, one_time_keyboard: true, resize_keyboard: true)
      end
    end
  end
end
