class CreateTimeslots < ActiveRecord::Migration[5.2]
  def change
    create_table :timeslots do |t|
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end
  end
end
