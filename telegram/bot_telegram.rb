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
    puts 'Bot started'
    puts '*' * 30
    bot.listen do |message|
      @bot_controller = TelegramBot::BotController.new(message: message, store_params: store_params)
      send_message(message.chat.id, bot_controller.return_answer)
    rescue StandardError => e
      puts e
      # logger(message: message, errors: e)
      # send_errors_for_admin
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

  def logger(message:, errors:)
    return if message.blank?

    value = '*' * 100
    value += "\nTG_id: #{message.chat.id}\nName: #{message.chat.first_name if message.chat.first_name.present?}\n"
    value += "Message: #{message.text}\nTime: #{Time.now}\nErrors: #{errors.full_message}\n"
    value += '*' * 100
    puts value
    # ActiveSupport::Logger.new('log/telegram_bot.log').info(value)
  end

  def send_errors_for_admin
    return unless File.exist?('../log/telegram_bot.log')

    bot.api.sendDocument(chat_id: 397034025, document: Faraday::UploadIO.new('../log/telegram_bot.log', 'text/plain'))
  end
end
