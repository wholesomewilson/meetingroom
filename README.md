<img src="https://github.com/wholesomewilson/moonlightsg/blob/master/app/assets/images/moonlight.png" width="150">

## Tech Stacks

Ruby on Rails, jQuery, HTML, CSS, Docker.

Dockerized and deployed on Digital Ocean - http://157.245.14.229:3000/

##Assumptions

1. A total of 20 rooms with 4 varying sizes (5, 8, 10, 12pax) in the office
2. Users are able to book the rooms in intervals of 30mins, starting from 7am and ending from 7pm
3. Users are able to book rooms up to 2months in advance

##Features

Check for room availability
Booking of rooms
Supports booking for multiple slots and rooms
Transferring of rooms to another colleague

##Challenges

###Availability of Room based on User search input
This is the main problem to tackle for the room booking application. The solutions were narrowed down to the followings.

1. Maintain a master list of all possible time slots
- Keep a list of all 21120 time slots (20room * 24 slots * 44 working days)
- Update the list whenever a booking is made accordingly

2. Keep track of booked time slots and compute available time slots on demand
- Create a "master list" of rooms and time slot based on user's search input of start and end date, start and end time
- Subtract booked slot from the "master list" and return as search result

Trade Offs
1. Maintaining a master list will have a high space cost as compared to keep tracking of booked slots
2. Computing available rooms on demand may have performance issue if user queries a large data set

This app uses Solution #2 to search for available rooms and time slots. As compared to keeping a master list which has a best case for space complexity of O(n) where n is the number of rooms), keeping track of booked slot will have a worst case of O(n) space complexity if all the rooms are fully booked for the period of 2 months. Additionally, performance issue will only arise if the user search for a wide range of dates, time and rooms.

###Double Bookings
Double booking will occur when a user books a slot from a stale page. The app implements a double checking approach to prevent it. The first check is done during the search for available room. The second check is done against existing bookings when user submit the booking form.

###Fixed interval or Dynamic Time slots?
Having dynamic time slots provide user with flexibility and good user experience. However, meetings are usually held in intervals of 30mins or 1hour. The occurrence of having a user booking a room to the exact minute is slim. Moreover, having a fixed interval model has its advantages in simplicity for design and ease of management in the app. With fixed interval time slot, it is easier to implement and manage multiple bookings across rooms, dates and time which is a more desired feature.

###Too many search results
The constraint of 2 months for advance booking helps in reducing the volume of time slots for search results as well as managing booked slots. The app implements pagination and a clean layout to provide good user experience.


## License
A short snippet describing the license (MIT, Apache etc)

MIT © [Wilson Wan]()
