class RenameSampleColumns < ActiveRecord::Migration
  def up
    change_table :pfxed_samples do |t|
      t.rename(:update, :update_function)
      t.rename(:draw, :draw_function)
      t.rename(:init, :init_function)
    end
  end

  def down
    change_table :pfxed_samples do |t|
      t.rename(:update_function, :update)
      t.rename(:draw_function, :draw)
      t.rename(:init_function, :init)
    end
  end
end
