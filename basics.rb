house = ["tralalero tralala", "bombardino crocodillo", "assasino capuchino"]

new_house = []

house.delete_if do |member|
  new_house.push(member)
end

p new_house, house
