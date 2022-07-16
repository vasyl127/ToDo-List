module TelegramBot
  class KeyboardsController
    KEY_FOR_PROJECT = %w[AddCost DeleteProject].freeze

    attr_reader :builder, :keys

    def initialize
      @keys = keys_list
      @builder = ::TelegramBot::Keyboard::Builder.new
    end

    def generate_inline_buttons(buttons)
      builder.generate_inline_buttons(buttons)
    end

    def generate_bottom_buttons(buttons)
      builder.generate_bottom_buttons(buttons)
    end

    def keys_list
      { create_project: locale('create_project'),
        projects_list: locale('projects_list'),
        create_cost: locale('create_cost'),
        share_project: locale('share_project'),
        delete_project: locale('delete_project'),
        home: locale('home') }
    end

    def start_keyboard
      kb = [keys[:projects_list], keys[:create_project]]

      builder.generate_bottom_buttons kb
    end

    def in_project_keyboard
      kb = [keys[:create_cost], keys[:share_project], keys[:delete_project], keys[:home]]

      builder.generate_bottom_buttons kb
    end

    def projects_keyboard(projects)
      kb = []
      projects.each { |project| kb << project } if projects.present?
      kb << [keys[:home]]

      builder.generate_bottom_buttons kb
    end

    private

    def locale(value)
      I18n.t("telegram.buttons.#{value}")
    end
  end
end
