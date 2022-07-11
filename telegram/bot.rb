require File.expand_path('../config/environment', __dir__)
require 'telegram/bot'
TOKEN = '5414064946:AAF22EGuVkIsSOn9ybY2t45H4yul8cq1qKY'.freeze

include ::TelegramBot::Authorizable
include ::TelegramBot::Operations::CreateTask
include ::TelegramBot::Operations::ShowTask


step = ''
task_params = {}
user_params = {}
Telegram::Bot::Client.run(TOKEN) do |bot|
  bot.listen do |message|
    if authorize?(message.chat.id)
      case step
      when 'create_task'
        task_params[:name] = message.text
        task_params[:text] = 'Created in TG bot'
        @task = create_task(telegram_id: message.chat.id, task_params: task_params)
        if @task.errors.empty?
          bot.api.send_message(chat_id: message.chat.id, text: 'Successfully created!')
          step = ''
        else
          bot.api.send_message(chat_id: message.chat.id, text: "#{@task.errors.full_messages} \n You can try again!")
        end
      end
      case message.text
      when '/start'
        bot.api.send_message(chat_id: message.chat.id, text: "Hello, #{message.from.first_name}")
      when '/create_task'
        bot.api.send_message(chat_id: message.chat.id, text: 'Enter a name task:')
        step = 'create_task'
      when '/tasks'
        bot.api.send_message(chat_id: message.chat.id,
                             text: "#{message.from.first_name}, task list: \n#{task_list(message.chat.id).pluck(:name)}")
      when '/stop'
        bot.api.send_message(chat_id: message.chat.id, text: "Bye, #{message.from.first_name}")
      end
    else
      case step
      when ''
      bot.api.send_message(chat_id: message.chat.id, text: 'No user found =( /n You can registration! Enter email:')
      step = 'reg_pass'
      when 'reg_pass'
        user_params[:email] = message.text
        user_params[:name] = message.from.first_name
        bot.api.send_message(chat_id: message.chat.id, text: 'Enter password:')
        step = 'reg_final'
      when 'reg_final'
        user_params[:password] = message.text
        user_params[:telegram_id] = message.chat.id
        @user = ::TelegramBot::Operations::UserCreate.new(user_params).user
        if @user.errors.empty?
          bot.api.send_message(chat_id: message.chat.id, text: 'Successfully created!')
          step.clear
        else
          bot.api.send_message(chat_id: message.chat.id, text: "#{@user.errors.full_messages} /n You can try again!")
          step.clear
        end

      end
    end
  end
end
