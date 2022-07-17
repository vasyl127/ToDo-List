module TelegramBot
  module Commands
    class PrepareCost
      include ::TelegramBot::Errors

      attr_reader :answer, :message, :user_telegram_id, :errors, :steps_controller, :params, :keyboard, :cost

      def initialize(params)
        @params = params
        @message = params[:message]
        @user_telegram_id = params[:user_telegram_id]
        @errors = params[:errors]
        @steps_controller = params[:steps_controller]
        @keyboard = params[:keyboard]
        @cost = find_cost

        exec_command
      end

      private

      def exec_command
        @answer = send(steps_controller.current_step)
        steps_controller.next_step
      end

      def in_cost
        { text: prepare_cost,
          keyboard: keyboard.in_cost_keyboard }
      end

      def operation_in_cost
        case message
        when keyboard.secondary_keys[:delete_cost]
          delete_cost
        else
          steps_controller.default_steps
          { text: 'In Progres maybe =)', keyboard: start_keyboard }
        end
      end

      def delete_cost
        value = { telegram_id: user_telegram_id,
                  project_name: params[:store_params].store.dig(user_telegram_id, :project_name),
                  cost_name: params[:store_params].store.dig(user_telegram_id, :cost_name) }
        ::CostOperations::Delete.new(value).delete_cost
        steps_controller.default_steps
        { text: I18n.t('telegram.messages.delete_cost'), keyboard: keyboard.start_keyboard }
      end

      def prepare_cost
        "📈 #{cost.name}\n📆 #{cost.created_at.strftime('%m.%d.%Y')}\n💸 #{cost.title}"
      end

      def find_cost
        project_name = params[:store_params].store.dig(user_telegram_id, :project_name)
        cost_name = params[:store_params].store.dig(user_telegram_id, :cost_name)
        ::CostOperations::Show.new(telegram_id: user_telegram_id, project_name: project_name).return_cost(cost_name)
      end
    end
  end
end
