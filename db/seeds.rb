# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
User.all.each do |user|
  20.times do |i|
    project = Project.create(name: "Prject ##{i}")
    5.times do |k|
      project.costs.create(name: "cost ##{k}", title: k * 100)
    end
    UserProject.create(user_id: user.id, project_id: project.id)
  end
end
