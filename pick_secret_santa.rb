#!/Users/tarsa/.rbenv/shims/ruby
require 'pry'

private
def pick_partner(target, list, constraints)

  return if list.empty?
  list = list - [target]

  partner = list[rand(list.length)]
  partner = list[rand(list.length)] while partner == constraints[target]
  partner
end

public
# returns array [ { target: , recipient: , e-mail: }, ...]
def pick_partners()
  names = %w( Greg Ben Linda Kat Becca )
  #emails = %w( gltarsa@gmail.com museiskum@gmail.com ltarsa@collegenannies.com kftarsa@gmail.com becca.tarsa@gmail.com )
  emails = Array.new(names.length, "tarsa@nc.rr.com")

  constraints = { "Linda" => "Greg", "Greg" => "Linda" }

  list = []

  names.each_with_index do |name, i|
    if [name] == names # degenerate case: when giver == recipient, recurse.
      return pick_partners()
    end

    partner = pick_partner(name, names, constraints)
    names -= [partner]
    list << { giver: "#{name}", recipient: "#{partner}", email: "#{emails[i]}" }
  end
  list
end 

dry_run = true
assignments = pick_partners()
subject = "You are officially a Secret Santa"

assignments.each do |set|
  msg_body =  <<-EOF
        Dear Elf #{set[:giver]},

        The Magic Selector has selected. You have been chosen to be Secret Santa for #{set[:recipient]}.

        Your giving budget is 125.00 dollars.

        Have a Merry Christmas--and go make it a Merry Christmas for #{set[:recipient]}!

        Warm Wishes,
        Electric Santa
  EOF

  if dry_run
    puts "msg_body=\n#{msg_body}----------\n" if set == assignments[0]
    puts "would execute = %x( echo '<msg_body>' | mailx -s '#{subject}' #{set[:email]} )"
  else
    puts "Sending assignment to #{set[:email]}"
    result = %x( echo '#{msg_body}' | mailx -s "#{subject}" #{set[:email]} )
    status = $?
      if status
        puts "mail succeeded"
        puts "result=#{result}" unless result.empty?
    else
      raise "Mail to elf #{name} failed.  Stopping e-mail to others."
    end
  end
end


