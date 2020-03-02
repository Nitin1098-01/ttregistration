class CreateBookings < ActiveRecord::Migration[6.0]
  def change
    create_table :bookings do |t|
      t.time :start_time
      t.time :end_time

      t.timestamps
    end
  end
end
