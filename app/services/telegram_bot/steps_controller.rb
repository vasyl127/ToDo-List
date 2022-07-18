# frozen_string_literal: true

module TelegramBot
  class StepsController
    HOME              = { list_name: 'HOME', steps_list: %w[home_screen] }.freeze
    REGISTRATION      = { list_name: 'REGISTRATION', steps_list: %w[email password] }.freeze
    PROJECTS_LIST     = { list_name: 'PROJECTS_LIST',
                          steps_list: %w[show_projects in_project operation_in_project] }.freeze
    CREATE_PROJECT    = { list_name: 'CREATE_PROJECT', steps_list: %w[fill_name save_fill_name] }.freeze
    CREATE_COST       = { list_name: 'CREATE_COST', steps_list: %w[fill_name save_fill_name] }.freeze
    SHARE_PROJECT     = { list_name: 'SHARE_PROJECT', steps_list: %w[user_list share_with_user] }.freeze
    PREPARE_COST      = { list_name: 'PREPARE_COST', steps_list: %w[in_cost operation_in_cost] }.freeze
    LANGUAGE          = { list_name: 'LANGUAGE', steps_list: %w[language_list language_set] }.freeze
    CREATE_TASK       = { list_name: 'CREATE_TASK', steps_list: %w[fill_name save_fill_name] }.freeze
    TASKS_LIST        = { list_name: 'TASKS_LIST', steps_list: %w[show_tasks in_task operation_in_task] }.freeze

    attr_reader :current_user, :current_step, :steps, :steps_list_name

    def initialize(current_user)
      @current_user = current_user
      default_steps if current_user.telegram_step.nil?
      params = eval(current_user.telegram_step)
      @current_step = params[:current_step]
      @steps_list_name = params[:list_name].upcase
      @steps = self.class.const_get(steps_list_name)[:steps_list]
    end

    def default_steps
      update_params(current_step: 'home_screen',
                    list_name: HOME[:list_name],
                    steps_list: HOME[:steps_list])
    end

    def start_create_task
      first_step CREATE_TASK
    end

    def start_tasks_list
      first_step TASKS_LIST
    end

    def start_create_project
      first_step CREATE_PROJECT
    end

    def start_create_cost
      first_step CREATE_COST
    end

    def start_registrations
      first_step REGISTRATION
    end

    def start_projects_list
      first_step PROJECTS_LIST
    end

    def start_prepare_cost
      first_step PREPARE_COST
    end

    def start_share_project
      first_step SHARE_PROJECT
    end

    def start_language_set
      first_step LANGUAGE
    end

    def next_step
      steps_list = []
      steps_list.replace steps
      return default_steps if steps_list.count <= 1

      steps_list.shift
      update_params(current_step: steps_list.first,
                    list_name: steps_list_name,
                    steps_list: steps_list)
    end

    private

    def first_step(const)
      update_params(current_step: const[:steps_list].first,
                    list_name: const[:list_name],
                    steps_list: const[:steps_list])
    end

    def update_params(current_step:, list_name:, steps_list:)
      @current_step = current_step
      @steps_list_name = list_name
      @steps = steps_list
      update_user_step(current_step: current_step, list_name: list_name)
    end

    def update_user_step(current_step:, list_name:)
      telegram_step = { current_step: current_step, list_name: list_name }
      current_user.update(telegram_step: telegram_step)
    end
  end
end
