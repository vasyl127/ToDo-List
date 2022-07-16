module TelegramBot
  module Commands
    class ProjectList

      include ::TelegramBot::Errors

      attr_reader :errors, :user_telegram_id, :keyboard, :steps_controller, :message, :answer, :project_name, :params

      def initialize(params)
        @params = params
        @errors = params[:errors]
        @message = params[:message]
        @steps_controller = params[:steps_controller]
        @user_telegram_id = params[:user_telegram_id]
        @keyboard = params[:keyboard]

        exec_command
      end

      private

      def exec_command
        @answer = send(steps_controller.current_step)
        steps_controller.next_step if steps_controller.steps_list_name == 'PROJECTS_LIST'
      end

      def show_projects
        { text: "#{I18n.t('telegram.messages.projects_list')}:\n",
          keyboard: keyboard.projects_keyboard(search_projects.pluck(:name)) }
      end

      def in_project
        steps_controller.next_step

        { text: formated_project(search_project, search_costs),
          keyboard: keyboard.in_project_keyboard }
      end

      def operation_in_project
        case message
        when keyboard.keys[:create_cost]
          create_cost
        else
          steps_controller.default_steps
          { text: 'InProgress, maybe ;)', keyboard: keyboard.start_keyboard }
        end
      end

      def create_cost
        steps_controller.start_create_cost
        ::TelegramBot::Commands::CreateCost.new(params).answer

        { text: I18n.t('telegram.messages.fill_cost_name') }
      end

      def formated_project(project, costs)
        string = "📄 #{project.name}\n📆 #{project.created_at.strftime('%m.%d.%Y')}\n\n"
        costs.each { |cost| string += "📈 #{cost.name} : #{cost.title}💸\n" } if costs.present?
        string += "\n#{I18n.t('telegram.messages.total')}: #{costs_total(costs)}💸"

        string
      end

      def search_costs
        ::CostOperations::Show.new(telegram_id: user_telegram_id, project_name: project_name).return_costs
      end

      def costs_total(costs)
        costs.pluck(:title).map(&:to_d).sum
      end

      def search_project
        @project_name = message
        params[:store_params].store_value(telegram_id: user_telegram_id, value: message)
        project = ::ProjectOperations::Show.new(telegram_id: user_telegram_id).return_project(project_name)
        return errors.add_errors(project_absent) if project.blank?

        project
      end

      def search_projects
        ::ProjectOperations::Show.new(telegram_id: user_telegram_id).return_projects
      end
    end
  end
end
