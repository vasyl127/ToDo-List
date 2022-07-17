# frozen_string_literal: true

module TelegramBot
  module Commands
    class ShareProject
      include ::TelegramBot::Errors

      attr_reader :errors, :user_telegram_id, :keyboard, :steps_controller, :message, :answer, :project_name, :params

      def initialize(params)
        @params = params
        @errors = params[:errors]
        @message = params[:message]
        @steps_controller = params[:steps_controller]
        @user_telegram_id = params[:user_telegram_id]
        @keyboard = params[:keyboard]
        @project_name = params[:store_params].store.dig(user_telegram_id, :project_name)

        exec_command
      end

      private

      def exec_command
        @answer = send(steps_controller.current_step)
        steps_controller.next_step if steps_controller.steps_list_name == 'SHARE_PROJECT'
      end

      def user_list
        { text: "#{I18n.t('telegram.messages.projects_list')}:\n",
          keyboard: keyboard.projects_keyboard(all_users) }
      end

      def share_with_user
        user_email = message
        user = User.find_by(email: user_email)
        UserProject.create(user_id: user.id, project_id: project.id)

        { text: "#{I18n.t('telegram.messages.share_project')} '#{user_email}'", keyboard: keyboard.start_keyboard }
      end

      def normalize_users
        value = []
        all_users.each { |user| value << "email: #{user.email}, name: #{user.name}" }

        value
        # all_users.pluck(:name)
      end

      def all_users
        User.all.pluck(:email) - [current_user.email]
      end

      def project
        current_user.projects.find_by(name: project_name)
      end

      def current_user
        User.find_by(telegram_id: user_telegram_id)
      end
    end
  end
end
