module TelegramBot
  class Storage
    attr_reader :store

    def store_value(telegram_id:, value:)
      return store[telegram_id].merge! value if store.present?

      @store = { telegram_id => value }
    end
  end
end
