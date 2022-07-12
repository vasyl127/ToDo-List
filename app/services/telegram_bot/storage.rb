module TelegramBot
  class Storage
    attr_reader :store

    def store_value(telegram_id:, value:)
      @store = { telegram_id => value }
    end
  end
end