# frozen_string_literal: true

require File.expand_path('../config/environment', __dir__)
require 'telegram/bot'

class BotTelegram
  include ::TelegramBot::Authorizable

  TOKEN = '5414064946:AAF22EGuVkIsSOn9ybY2t45H4yul8cq1qKY'

  attr_reader :store_params, :bot_controller

  def initialize
    @store_params = ::TelegramBot::Storage.new
  end

  def run
    bot.listen do |message|
      @bot_controller = TelegramBot::BotController.new(message: message, store_params: store_params)
      send_message(message.chat.id, bot_controller.return_answer)
    rescue StandardError => e
      puts e.full_message
    end
  end

  private

  def bot
    Telegram::Bot::Client.run(TOKEN) { |bot| return bot }
  end

  def send_message(chat_id, answer)
    message = answer[:text]
    kb = answer[:keyboard]
    return bot.api.sendMessage(chat_id: chat_id, text: message) if kb.blank?

    bot.api.sendMessage(chat_id: chat_id, text: message, reply_markup: kb)
  end
end
