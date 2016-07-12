def create_reservations(count, start_date, end_date)
  random = Random.new
  days = (end_date - start_date).to_i + 1
  start_date = start_date.beginning_of_day

  nooks = Nook.limit(2)
  user_id = User.first.id

  reservation = Reservation.last
  id = 1
  unless reservation.nil?
    id = reservation.id + 1
  end

  (1..count).each do
    stime = start_date + (random.rand(days)).days
    half_hours = (random.rand(18..28))
    stime = stime + (half_hours / 2).hours
    stime = stime + 30.minutes if half_hours % 2 == 1

    duration = random.rand(1..6)
    etime = stime + (duration / 2).hours
    etime = etime + 30.minutes
    etime = etime - 1.seconds

    Reservation.create(
      name: "Reservation #{id}",
      nook: nooks[random.rand(2)],
      start: stime,
      end: etime,
      status: Reservation::Status::CONFIRMED,
      user_id: user_id
    )
    id = id + 1
  end

end

create_reservations(
  100,
  Date.new(2016, 7, 1),
  Date.new(2016, 7, 31)
)

create_reservations(
  500,
  Date.new(2016, 1, 1),
  Date.new(2016, 12, 31)
)
