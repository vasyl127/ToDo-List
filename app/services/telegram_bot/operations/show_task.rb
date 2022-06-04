module TelegramBot
  module Operations
    module ShowTask
      def task_list(id)
        ::TelegramBot::Authorizable.current_user(id).tasks
      end  
    end
  end
end