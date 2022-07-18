# frozen_string_literal: true

module TelegramBot
  module Commands
    class TasksList
      include ::TelegramBot::Errors

      attr_reader :answer, :message, :user_telegram_id, :errors, :steps_controller, :params, :keyboard

      def initialize(params)
        @params = params
        @message = params[:message]
        @user_telegram_id = params[:user_telegram_id]
        @errors = params[:errors]
        @steps_controller = params[:steps_controller]
        @keyboard = params[:keyboard]

        exec_command
      end

      private

      def exec_command
        @answer = send(steps_controller.current_step)
        steps_controller.next_step
      end

      def show_tasks
        { text: format_tasks_list, keyboard: keyboard.tasks_keyboard }
      end

      def in_task

      end

      def operation_in_task

      end

      def format_tasks_list
        string = ''
        tasks = search_tasks
        return errors.add_errors(tasks_absent) unless tasks.present?

        tasks.each { |task| string += "💼 #{task.name}\n📆 #{task.created_at.strftime('%m.%d.%Y')}\n  \n" }

        string
      end

      def search_tasks
        ::TaskOperations::Show.new(user_telegram_id: user_telegram_id).return_tasks
      end
    end
  end
end
