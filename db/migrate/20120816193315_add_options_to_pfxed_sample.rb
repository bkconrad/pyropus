class AddOptionsToPfxedSample < ActiveRecord::Migration
  def change
    add_column :pfxed_samples, :max_particles, :integer
    add_column :pfxed_samples, :emit_frequency, :integer
    add_column :pfxed_samples, :boundary_action, :string
  end
end
