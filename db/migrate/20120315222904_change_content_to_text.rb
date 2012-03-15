class ChangeContentToText < ActiveRecord::Migration
  def up
    change_table :posts do |t|
      t.remove :content
      t.text :content
    end
  end

  def down
    change_table :posts do |t|
      t.remove :content
      t.string :content
    end
  end
end
