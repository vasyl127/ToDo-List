module TelegramBot
  module Commands
    class CreateCost
      include ::TelegramBot::Errors

      attr_reader :answer, :message, :telegram_id, :errors, :steps_controller, :params, :project_name, :keyboard

      def initialize(params)
        @params = params
        @message = params[:message]
        @telegram_id = params[:user_telegram_id]
        @errors = params[:errors]
        @steps_controller = params[:steps_controller]
        @project_name = params[:store_params].store[telegram_id]
        @keyboard = params[:keyboard]

        exec_command
      end

      private

      def exec_command
        @answer = send(steps_controller.current_step)
        steps_controller.next_step
      end

      def fill_name
        { text: I18n.t('telegram.messages.fill_cost_name') }
      end

      def save_fill_name
        params[:cost_params] = prepare_cost_params
        steps_controller.next_step

        { text: create_cost, keyboard: keyboard.start_keyboard }
      end

      def prepare_cost_params
        return { name: message } unless message.include?(':')

        value = message.split(':')
        { name: value.first, title: value.last }
      end

      def create_cost
        cost = ::CostOperations::Create.new(params).cost
        return I18n.t('telegram.messages.cost_created') unless cost.errors.any?

        errors.add_errors(cost.errors.full_messages)
      end
    end
  end
end
