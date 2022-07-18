# frozen_string_literal: true

module TelegramBot
  class KeyboardsController
    KEY_FOR_PROJECT = %w[AddCost DeleteProject].freeze

    attr_reader :builder, :keys, :secondary_keys

    def initialize
      @keys = primary_keys_list
      @secondary_keys = secondary_keys_list
      @builder = ::TelegramBot::Keyboard::Builder.new
    end

    def generate_inline_buttons(buttons)
      builder.generate_inline_buttons(buttons)
    end

    def generate_bottom_buttons(buttons)
      builder.generate_bottom_buttons(buttons)
    end

    def primary_keys_list
      { create_project: locale('create_project'),
        projects_list: locale('projects_list'),
        create_task: locale('create_task'),
        tasks_list: locale('tasks_list'),
        language: locale('language'),
        share_project: locale('share_project'),
        home: locale('home') }
    end

    def secondary_keys_list
      { delete_cost: locale('delete_cost'),
        create_cost: locale('create_cost'),
        delete_project: locale('delete_project'),
        language_ua: locale('language_ua'),
        language_en: locale('language_en') }
    end

    def start_keyboard
      kb = [[keys[:tasks_list], keys[:projects_list]], [keys[:create_task], keys[:create_project]], keys[:language]]

      builder.generate_bottom_buttons kb
    end

    def in_project_keyboard
      kb = [secondary_keys[:create_cost], keys[:share_project], secondary_keys[:delete_project], keys[:home]]

      builder.generate_bottom_buttons kb
    end

    def in_cost_keyboard
      kb = [secondary_keys[:delete_cost], keys[:home]]

      builder.generate_bottom_buttons kb
    end

    def language_keyboard
      kb = [[secondary_keys[:language_ua], secondary_keys[:language_en]], keys[:home]]

      builder.generate_bottom_buttons kb
    end

    def tasks_keyboard
      kb = [keys[:create_task], keys[:home]]

      builder.generate_bottom_buttons kb
    end

    def projects_keyboard(projects)
      kb = []
      projects.each { |project| kb << project } if projects.present?
      kb << [keys[:create_project]] << [keys[:home]]

      builder.generate_bottom_buttons kb
    end

    private

    def locale(value)
      I18n.t("telegram.buttons.#{value}")
    end
  end
end
