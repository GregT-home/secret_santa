require 'pry'

names = %w( Greg Ben Linda Kat Becca )
constraints = { "Linda" => "Greg", "Greg" => "Linda" }

def pick_partner(target, list, constraints)

  return if list.empty?
  list = list - [target]

  partner = list[rand(list.length)]
  partner = list[rand(list.length)] while partner == constraints[target]
  partner
end

for name in names do
  partner = pick_partner(name, names, constraints)
  puts "#{name} is getting a gift for #{partner}"
  names -= [partner]
end
