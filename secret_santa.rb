#!/Users/tarsa/.rbenv/shims/ruby
require 'pry'

class Person
  attr_accessor :first_name, :last_name, :email

  def initialize(name)
    @first_name, @last_name, @email = name
  end
  def full_name
    "#{@first_name} #{@last_name}"
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
  return_hash = []
  list.each do |person|
    if degenerate(person, list)
      return pick_partners(starting_list)
    end

    partner = pick_partner(person, list)
    list -= [partner]
    return_hash << { giver: "#{person.full_name}", recipient: "#{partner.full_name}", email: "#{person.email}" }
  end
  return_hash
end

def degenerate(person, list)
  if [person] == list
    true
  else
    feasible = list.reject { |e| e.last_name == person.last_name }
    return !feasible.any?
  end
end

list = []

while line = gets do
  line = line.chomp
  list << Person.new(line.split)
end

assignments = pick_partners(list)
puts "---------------- assignments:\n"
assignments.each do |assignment|
  puts "echo '#{assignment[:giver]}, You give your gift to #{assignment[:recipient]}.' #{assignment[:email]} | mail -s 'You are a secret santa!'"
end

