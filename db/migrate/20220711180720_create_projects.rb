class CreateProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :projects do |t|
      t.string :name
      t.date :deleted_at
      t.string :user_created

      t.timestamps
    end
  end
end
