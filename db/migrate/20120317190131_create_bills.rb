class CreateBills < ActiveRecord::Migration
  def change
    create_table :bills do |t|
      t.string :bill
      t.integer :congress
      t.string :title
      t.string :sponsor
      t.date :introduced_date
      t.string :committees
      t.date :latest_major_action_date
      t.string :latest_major_action

      t.timestamps
    end
  end
end
