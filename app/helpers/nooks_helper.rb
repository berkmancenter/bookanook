module NooksHelper
  def nook_capacity
    array = (Nook.minimum(:min_capacity) || 0)..(Nook.maximum(:max_capacity) || 0)
    return array.map{ |x| x > 0 ? [x, x] : [x, "Any"] }.to_h
  end
end
