class CreatePfxedSamples < ActiveRecord::Migration
  def change
    create_table :pfxed_samples do |t|
      t.string :name
      t.text :init
      t.text :draw
      t.text :update

      t.timestamps
    end
  end
end
