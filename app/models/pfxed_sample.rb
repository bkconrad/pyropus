class PfxedSample < ActiveRecord::Base
  attr_accessible :init_function, :draw_function, :update_function, :name, :emit_frequency, :max_particles, :boundary_action
end
