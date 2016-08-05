require "csv"
require "erb"

class People
  attr_accessor :name, :phone, :address, :position, :salary, :github

  def initialize(name)
    @name = name
  end
end

class Menu
  def initialize
    @people = []

    CSV.foreach("employees.csv", { headers: true, header_converters: :symbol }) do |employee|
      person = People.new(employee)

      person.name     = employee[:name]
      person.phone    = employee[:phone]
      person.address  = employee[:address]
      person.position = employee[:position]
      person.salary   = employee[:salary]
      person.github   = employee[:github]

      @people << person
    end
  end

  def prompt
    loop do
      puts "A for Add a person"
      puts "S for Search for a person"
      puts "D for Delete a person"
      puts "R for Employee Report"
      puts "E for Exit"

      choice = gets.chomp
      break if choice == "E"

      case choice
      when "A"
        add_person
      when "S"
        search_person
      when "D"
        delete_person
      when "R"
        report
      else
        puts "These are your only options"
      end
    end
  end

  def write
    CSV.open("employees.csv", "w") do |csv|
      csv << %w{name phone address position salary github}
      @people.each do |person|
        csv << [person.name, person.phone, person.address, person.position,person.salary, person.github]
      end
    end
  end

  def add_person
    puts "Enter employee first and last name"
    name = gets.chomp

    person = People.new(name)

    puts "Enter employee phone number"
    phone = gets.chomp

    puts "Enter employee address"
    address = gets.chomp

    puts "Employee's position"
    position = gets.chomp

    puts "Employee's salary"
    salary = gets.chomp

    puts "Employee's github account"
    github = gets.chomp

    @people << person

    write
    puts "#{@people [-1].name} has been added to your database."
  end

  def found(person)
    puts "Employee is listed:
          #{person.name}
          #{person.phone}
          #{person.address}
          #{person.position}
          #{person.salary}
          #{person.github}"
  end

  def search_person
    puts "Whom is it for which you look?"
    search_person = gets.chomp
    matching_person = @people.find { |person| person.name == search_person }
    if !matching_person.nil?
      found(matching_person)
    else puts "#{search_person}not found"
    end
  end

  def delete_person
    puts "Delete which Employee? "
    delete_employee = gets.chomp
    matching_person = @people.find { |person| person.name == delete_person }
    for person in @people
      if !matching_person.nil?
        @people.delete(matching_person)
        write
        puts "#{person.name} has been deleted."
        break
      else
        puts "Person not found"
      end
    end
  end

  def report
    puts "An employee report is being created for you now"

    # Read the template.html.erb and shove it into a variable
    # called html_template_from_disk.
    html_template_from_disk = File.read("template.html.erb")

    # Make a new ERB object and give it the `String` from html_template_from_disk
    erb_template = ERB.new(html_template_from_disk)

    positions = []

    # Do the "mail merge" like `magic`
    output = erb_template.result(binding)

    # Write that out to a report.html file
    File.open("report.html", "w") do |file|
      file.puts output
    end
  end
end

menu = Menu.new()
menu.prompt
