module TelegramBot
  module Operations
    module CreateTask
      def create_task(params)
        ::TaskOperation::Create.new(params).task
      end
    end
  end
end
