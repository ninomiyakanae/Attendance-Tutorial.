class AddBbbInfoToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :a_start_at, :datetime, default: Time.current.change(hour: 9, min: 0, sec: 0)
    add_column :users, :a_finish_at, :datetime, default: Time.current.change(hour: 17, min: 0, sec: 0)
  end
end
