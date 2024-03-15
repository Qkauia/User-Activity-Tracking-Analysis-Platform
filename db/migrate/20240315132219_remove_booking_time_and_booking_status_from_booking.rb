class RemoveBookingTimeAndBookingStatusFromBooking < ActiveRecord::Migration[7.1]
  def change
    remove_column :bookings, :booking_time
    remove_column :bookings, :booking_status
  end
end
