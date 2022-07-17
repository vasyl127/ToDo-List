# frozen_string_literal: true

module TelegramBot
  class ErrorsController
    attr_reader :errors

    def initialize
      @errors = []
    end

    def any?
      errors.present?
    end

    def none?
      errors.empty?
    end

    def add_errors(message)
      errors << message
    end

    def all_errors_messages
      string = "Errors:\n\n"
      errors.flatten.map { |error| string += "- #{error} \n" }.to_s

      string
    end
  end
end
