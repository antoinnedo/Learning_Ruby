house = ["tralalero tralala", "bombardino crocodillo", "assasino capuchino"]

new_house = []

house.delete_if do |member|
  new_house.push(member)
end

class Member
  @@number_of_members = 0
  attr_accessor :name, :age

  def initialize(name, age)
    @@number_of_members += 1
    @name = name
    @age = age
  end

  def self.number_of_members
    @@number_of_members
  end

  def to_s
    status = @age > 30 ? ", => old af" : nil

    "Member: #{@name}, Age: #{@age}#{status}"
  end

  def laugh
    "#{@name} is laughing"
  end
end

module GoodPerson
  def be_nice
    "*shares food"
  end
end

class AngryFoe < Member
  def warn
    "Stay away!"
  end
end

class HappyFriend < Member
  def greet
    "Hello!"
  end
end

class Baby < Member
  include GoodPerson
  def cry
    "OEOEOE"
  end
end

puts "#?: ", Member.number_of_members

haha = HappyFriend.new("haha",27)
hihi = HappyFriend.new("hihi", 35)
hehe = Baby.new("hehe", 20)
ahhh = AngryFoe.new("ahhh", 50)

puts "new #?: ", Member.number_of_members

puts haha
puts hihi
puts ahhh
puts hehe

puts haha.laugh
puts hihi.greet
puts ahhh.warn
puts hehe.be_nice

puts Baby.ancestors
