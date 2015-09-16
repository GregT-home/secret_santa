#!/Users/tarsa/.rbenv/shims/ruby
require 'pry'

class Person
  attr_accessor :first_name, :last_name, :email

  def initialize(name)
    @first_name, @last_name, @email = name
  end
end

def pick_partner(target, list)
  return if list.empty?
  list -= [target]

  partner = list[rand(list.length)]
  partner = list[rand(list.length)] while target.last_name == partner.last_name
  partner
end

def pick_partners(starting_list)
  list = starting_list
  list.each do |person|
    if [person] == list  # degenerate case; recurse
      return pick_partners(starting_list)
    end

    partner = pick_partner(person, list)
    names -= [partner]
    list << { giver: "#{name}", recipient: "#{partner}", email: "#{emails[i]}" }
  end
  list
end

list = []

while line = gets do
  line = line.chomp
  puts "line: #{line.split}"
  list << Person.new(line.split)
end
puts "#{list}"

assignments = pick_partners(list)
puts "#{assignments}"
