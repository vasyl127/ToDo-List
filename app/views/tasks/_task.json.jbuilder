json.extract! task, :id, :name, :text, :delete_at, :created_at, :updated_at
json.url task_url(task, format: :json)
