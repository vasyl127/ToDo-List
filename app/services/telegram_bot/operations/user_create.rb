module TelegramBot
  module Operations
    class UserCreate
      attr_reader :user

      def initialize(params)
        @user = User.new(params)

        registration
      end

      def registration
        @user.save
      end
    end
  end
end
