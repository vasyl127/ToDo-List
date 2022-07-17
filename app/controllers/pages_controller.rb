# frozen_string_literal: true

class PagesController < ApplicationController
  def ul_page
    @tasks = Task.last(3)
  end
end
