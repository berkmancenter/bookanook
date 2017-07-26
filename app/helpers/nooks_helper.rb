module NooksHelper
  def nook_capacity
    if Nook.where(min_capacity: nil).empty?
      min = Nook.minimum(:min_capacity)
    else
      min = 0
    end
    array = ( min..(Nook.maximum(:max_capacity) || (min + 1) ) ).to_a
    unless array.include?(0)
      array = [0] + array
    end
    return array.map{ |x| x > 0 ? [x, x] : [x, "Any"] }.to_h
  end
end
