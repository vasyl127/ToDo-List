class CreateCosts < ActiveRecord::Migration[7.0]
  def change
    create_table :costs do |t|
      t.string :name
      t.string :title
      t.string :deleted_at
      t.string :user_created
      t.integer :project_id

      t.timestamps
    end
  end
end