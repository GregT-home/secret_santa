#!/Users/tarsa/.rbenv/shims/ruby
class Person
  attr_accessor :first_name, :last_name, :email

  def initialize(name)
    @first_name, @last_name, @email = name
  end

  def full_name
    "#{@first_name} #{@last_name}"
  end
end

class List
  def initialize(name = nil)
    @list ||= []
    @list << name if name
  end

  def <<(name)
    @list << name
  end

  def pick_partners
    working_list = @list.shuffle
    return_hash = []
    working_list.each do |person|
      if degenerate(person, working_list)
        return pick_partners
      end

      partner = pick_partner(person, working_list)
      working_list -= [partner]
      return_hash << { giver: "#{person.full_name}",
                       recipient: "#{partner.full_name}",
                       email: "#{person.email}" }
    end
    return_hash
  end

  private

  def pick_partner(target, list)
    return if list.empty?
    list -= [target]

    partner = list[rand(list.length)]
    partner = list[rand(list.length)] while target.last_name == partner.last_name
    partner
  end

  def degenerate(person, list)
    if [person] == list
      true
    else
      feasible = list.reject { |e| e.last_name == person.last_name }
      return !feasible.any?
    end
  end
end

list = List.new

while line = gets do
  line = line.chomp
  list << Person.new(line.split)
end

assignments = list.pick_partners
assignments.each do |assignment|
  puts "echo '#{assignment[:giver]}, You give your gift to" +
    " #{assignment[:recipient]}.' #{assignment[:email]}" +
    " | mail -s 'You are a secret santa!'"
end

