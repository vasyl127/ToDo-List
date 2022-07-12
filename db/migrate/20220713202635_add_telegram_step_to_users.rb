class AddTelegramStepToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :telegram_step, :string
  end
end
