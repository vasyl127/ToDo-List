# frozen_string_literal: true

module TelegramBot
  module Errors
    def invalid_commands
      I18n.t('telegram.commands.invalid')
    end

    def project_absent
      I18n.t('telegram.errors.projects_not_found')
    end

    def tasks_absent
      I18n.t('telegram.errors.tasks_not_found')
    end
  end
end
