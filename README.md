## Setup

### Requirements

* Ruby 3.0.0
* Bundler 2

### Setup steps

* Clone repo `git clone <link to repo>`
* Run `bundle install`·
* Setup database `rails db:setup`
* Run server `rails s`
* Run sidekiq `bundle exec sidekiq`

### example api urls for main features

Display list of tickets for event
```
GET http://localhost:3000/api/v1/events/2/tickets
```

Create and reserve ticket
```
POST http://localhost:3000/api/v1/events/2/tickets?quantity=2
```

Display events list
```
GET http://localhost:3000/api/v1/events
```

Purchase reserved ticket.
```
POST http://localhost:3000/api/v1/payments?ticket_id=1
```



### My comments

To release reserved tickets after 15 minutes if not purchased, on server should be added crone job, set to run every minute and call `ReleaseReservedTicketsJob`

I dont create validations in `Ticket` model becouse I did it in `CreateTicketForm` (I want to keep it dry and only available access from api to tickets is by create method)

I dont raise errors if tickes or events are empty arrays, in my opinion it's not error or exception, and it's ok to return empty array.

I tried to not change too much in prepared structure, I only change these code that I thik was most important
