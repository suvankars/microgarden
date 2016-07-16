class FrameSize
  include Computation
  def self.all  
    Choices['sizes'].each.collect do |size| 
      measurement = Computation::Measurement.new
      measurement.length = size
      measurement
    end   
  end

  def self.options_for_select
      all.map{ |r| [r.to_cm, r.inch] }
  end
end