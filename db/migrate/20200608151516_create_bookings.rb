class CreateBookings < ActiveRecord::Migration[5.2]
  def change
    create_table :bookings do |t|
      t.references :user, foreign_key: true
      t.references :room, foreign_key: true
      t.references :timeslot, foreign_key: true
      t.datetime :start_date

      t.timestamps
    end
  end
end
