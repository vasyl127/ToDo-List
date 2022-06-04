module TelegramBot
  module Authorizable
    def authorize?(id)
      current_user(id).present?
    end

    def current_user(id)
      User.find_by(telegram_id: id)
    end
  end
end
