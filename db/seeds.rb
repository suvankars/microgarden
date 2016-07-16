# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


category_list = [
  [ "Workplace", "All Workplace goes here" ]
]


category_list.each do |name, description|
  Category.create( name: name, description: description )
end

subcategory_list = [
["Coffeehouse", "Coffeehouse..."],
["Restaurant", "Beautiful Restaurant, w..."],
["Bar", "Designed for rocking work"],
["Club","Designed for rocking work ..."], 
["Shopping mall","Designed for rocking work ..."] 
]

category_id = Category.where( name: "Workplace").first.id

subcategory_list.each do |name, description|
  Subcategory.create( name: name, description: description, category_id: category_id )
end