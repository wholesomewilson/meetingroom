## Tech Stacks

Ruby on Rails, jQuery, HTML, CSS, Docker.

Dockerized and deployed on Digital Ocean - http://165.22.38.63/

## Assumptions

1. A total of 20 rooms with 4 varying sizes (5, 8, 10, 12pax) in the office
2. Users are able to book the rooms in intervals of 30mins, starting from 7am and ending at 7pm
3. Users are able to book rooms up to 2months in advance

## Features

* Check room availability
* Book rooms
* Support booking for multiple time slots, rooms and dates
* Transfer rooms 
* Cancel rooms 

## Challenges

### Availability of Room based on User search input
This is the main problem for the room booking application. The approaches to tackle this problem are narrowed down to the followings.

1. Maintain a master list of all possible time slots
- Keep a list of all 21120 time slots (20room * 24 slots * 44 working days)
- Update the list whenever a booking is made accordingly

2. Keep track of booked time slots and compute available time slots on demand
- Create a "master list" of rooms and time slot based on user's search input of start and end date, start and end time
- Subtract booked slot from the "master list" and return as search result

Trade Offs
1. Maintaining a master list will have a high space cost as compared to keep tracking of booked slots
2. Computing available rooms on demand may have performance issue if user queries a large data set

I decided to go with Approach #2 to search for available rooms and time slots. As compared to keeping a master list which has a best case for space complexity of O(n) where n is the number of rooms, keeping track of booked slot will have a worst case of O(n) space complexity if all the rooms are fully booked for the period of 2 months. Additionally, performance issue will only arise if the user search for a wide range of dates, time and rooms which seldom happens.

### Double Bookings
Double booking will occur when a user books a slot from a stale page. The app implements a validation before creating the booking record. The validation is done against existing bookings when user submits the booking form.

### Fixed interval or Dynamic Time slots?
Having dynamic time slots provide user with flexibility and good user experience. However, meetings are usually held in intervals of 30mins or 1hour. The occurrence of having a user booking a room to the exact minute is low. Moreover, having a fixed interval model has its advantages in simplicity for design and ease of management in the app. With fixed interval time slot, it is easier to implement and manage multiple bookings across rooms, dates and time which is a more desired feature.

### Too many search results
The constraint of 2 months for advance booking helps in reducing the volume of time slots for search results as well as managing booked slots. The app implements pagination and a clean layout to provide good user experience.

## Brief Summary of Model Design

There are 4 models
1. User
2. Timeslot
3. Room
4. Booking

User has_many Rooms through Bookings
Room has_many User through Bookings

A user and a room will have a many-to-many relationship with each other through a joint table, Booking.

Booking belongs_to user, room and timeslot

In the Booking joint table, it will hold information on which room and timeslot is booked by a user. This joint table is also cruical to generate the availablity of rooms and timeslots.

## Strategy for getting room availablilty

3 sets of input from user on Search form

1. number of attendees - filter and reduce the number of rooms to search by their size
2. start date and end date - search through the bookings of the rooms in the filtered list and get their time slots if its start date falls between this input date range
3. start time and end time - generate a list of all timeslots within this range. Subtract the booked time slots with this list and we will get our available slots for the range of dates and rooms based on user input! :)

## Approach for booking multiple rooms, multiple timeslots across multiple dates

### Selection Checkbox
For each checkbox, it contains a unqiue id, value: timeslot.id, data-start_date: start_date, data-room_id: room.id.
Upon checking the box, 3 hidden input will be appended to a form.
Upon unchecking the box, the same 3 hidden input will be removed using it's unqiue id


### Handling multiple params in a nested hash

Params will be nested in the following hash structure. For the random key, I use epoch but it could be anything (e.g. running nums).
```
{ 
  bookings: { 
               "random unique key": { 
                                        timeslot_id: "",
                                        room_id:     "",
                                        start_date:  ""
                                     },
               "random unique key": { 
                                        timeslot_id: "",
                                        room_id:     "",
                                        start_date:  ""
                                     }
              }
}
```
In our Bookings controller, we will iterate through this hash and apply a custom validation to check for double booking
before creating the record.

Similarly, this approach is used for transfering and cancelling bookings in My Booking page.

### Security for Params
This approach seems abit hacky and doesn't follow the "Rails Way". However, we can still achieve similar level of security by using Strong Parameters.

```
params[:booking].each do |key, value|
  @booking = current_user.bookings.new(booking_params(value))
  if validation fails
    flash errors messages
    redirect_back
  end
  @booking.save
end

*Strong Parameter to save the day! privately..*

def booking_params(params)
  params.permit(:room_id, :timeslot_id, :start_date)
end
```

## Something Extra

### Using a nginx server to reduce time for first load

The long initial loading time will definitely trigger some of our users on their worst days. This is because rails has to pre-compile and serve the assets to the client for the first time our users load our page. Rails is good at handling business and produce dynamic informations. However, serving files is not its forte. Nginx will handle the serving of assets to the clients and leave rails to do its own stuff.

Curtains up, and enters **Nginx!**
1. Copy the assets in the public folder and paste them in the environment (VMs or Dockers) where nginx has access to. (e.g. /usr/share/nginx/html)

2. Change the configuration of /etc/nginx/conf.d/default.conf to the following code
```
server {
  listen 80;

  # Properly server assets
  location ~ ^/(assets)/ {
    root /usr/share/nginx/html;
    gzip_static on;
    expires max;
    add_header Cache-Control public;
    add_header ETag "";
  }

  # Proxy request to rails app
  location / {
    proxy_set_header Host $host;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_pass_header Set-Cookie;
    proxy_pass http://app:3000;
  }
}
```

3. Curtain down, it's a wrap.

### In case you're wondering

I run two dockers with two droplets. One for staging environment and the other for prod environment. Even though both are running the same codes now, I feel much safer to experiment new tech or new ways of doing things in the staging environment without worrying about potential irreversible changes.

http://165.22.38.63/ - prod

http://157.245.14.229/ - staging
