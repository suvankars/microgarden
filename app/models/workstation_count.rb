class WorkstationCount
  def self.all  
    Choices['workstations'].each.collect do |ws|
      ws.to_i
    end
  end

  def self.options_for_select
    all.map{ |w| w.to_i }
  end
end

 
