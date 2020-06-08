# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

@start = Time.new(2000, 1, 1, 7, 0, 0)
24.times do
  @end = @start + 30.minutes
  Timeslot.create(start_time: @start.strftime("%H:%M"), end_time: @end.strftime("%H:%M"))
  @start = @end
end

Room.create(unit: "1", name: "Mustafar", size: 5, hint: "Turn left from the pantry")
Room.create(unit: "2", name: "Tatooine", size: 5, hint: "Turn right from the pantry")
Room.create(unit: "3", name: "Geonosis", size: 5, hint: "Turn right from the money plant")
Room.create(unit: "4", name: "Wobani", size: 5, hint: "Turn left from the money plant")
Room.create(unit: "5", name: "Eadu", size: 5, hint: "Near big boss office")

Room.create(unit: "6", name: "Mygeeto", size: 8, hint: "Near big lady boss office")
Room.create(unit: "7", name: "Hoth", size: 8, hint: "Turn left from the Gents")
Room.create(unit: "8", name: "Jakku", size: 8, hint: "Turn right from the Gents")
Room.create(unit: "9", name: "Dagobah", size: 8, hint: "Turn left from the Ladies")
Room.create(unit: "10", name: "Felucia", size: 8, hint: "Turn right from the Ladies")

Room.create(unit: "11", name: "Utapau", size: 10, hint: "Walk towards the Gents")
Room.create(unit: "12", name: "Kamino", size: 10, hint: "Walk towards the Ladies")
Room.create(unit: "13", name: "Jedha", size: 10, hint: "Walk towards the pantry")
Room.create(unit: "14", name: "Crait", size: 10, hint: "Walk towards the money plant")
Room.create(unit: "15", name: "Alderaan", size: 10, hint: "Walk towards the place with many TVs")

Room.create(unit: "16", name: "Bespin", size: 12, hint: "Turn right from the big stairscase")
Room.create(unit: "17", name: "Coruscant", size: 12, hint: "Walk towards the lift lobby")
Room.create(unit: "18", name: "Naboo", size: 12, hint: "Look for the beer fridge")
Room.create(unit: "19", name: "Endor", size: 12, hint: "Look for the wine chiller")
Room.create(unit: "20", name: "Ithor", size: 12, hint: "It's near the ping ping table")
