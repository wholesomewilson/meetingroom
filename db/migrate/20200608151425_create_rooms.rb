class CreateRooms < ActiveRecord::Migration[5.2]
  def change
    create_table :rooms do |t|
      t.string :unit
      t.string :name
      t.integer :size
      t.text :hint

      t.timestamps
    end
  end
end
