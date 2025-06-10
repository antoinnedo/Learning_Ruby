class Player
  attr_accessor :marker
  attr_reader :name, :id

  def initialize(marker, name, id)
    @marker = marker
    @name = name
    @id = id
  end

  def switch_id!
    @id = @id == 1 ? 2 : 1
  end
end
