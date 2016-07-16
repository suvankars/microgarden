# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


category_list = [
  [ "Bicycle", "All Bicycles goes here" ]
]


category_list.each do |name, description|
  Category.create( name: name, description: description )
end

subcategory_list = [
["MTB", "A  mountain bicycle is a bicycle created for off-r..."],
["Fixies", "fixies are designed to be ridden on a velodrome, w..."],
["Road", "Designed for long ride on road"],
["Hybrid","Originally conceived to provide the advantages of ..."],
["Commuter", "When thinking about commuting to work ..."]
]

category_id = Category.where( name: "Bicycle").first.id

subcategory_list.each do |name, description|
  Subcategory.create( name: name, description: description, category_id: category_id )
end