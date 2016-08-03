require "csv"
require 'erb'

class Peep
  attr_accessor :name, :phone, :address, :position , :salary, :slack, :github

  def initialize(name)
    @name = name
  end
end

class Menu
  def initialize
    @peep = []

    CSV.foreach("employees.csv", { headers: true, header_converters: :symbol }) do |employee|
      person = peep.new(employee)

      person.name     = employee[:name]
      person.phone    = employee[:phone]
      person.address  = employee[:address]
      person.position = employee[:position]
      person.salary   = employee[:salary]
      person.slack    = employee[:slack]
      person.github   = employee[:github]

      @peep << person
    end
  end

  def prompt
    loop do
      puts "Please select the corresponding letter (A, S, R, C or D) as follows:"

      puts "A: Add a person"
      puts "S: Search for a person"
      puts "D: Delete a person"
      puts "R: Report of Employees"
      puts "C: Cancel search"

      chosen = gets.chomp

      case chosen
      when "A"
        add_person
      when "S"
        search_person
      when "D"
        delete_person
      when "R"
        report
      when "C"
        cancel_search
        exit
      else
        puts "Selections are limited to A, S, R, C or D only"
      end
    end
  end

  def write
    CSV.open("employees.csv", "w") do |csv|
      csv << %w{name phone address position salary slack github}
      @peep.each do |person|
        csv << [person.name, person.phone, person.address, person.position, person.salary, person.slack, person.github]
      end
    end
  end

  PREFIX = "Dear humanoid please provide the"

  def add_person
    puts "#{PREFIX} name"
    name = gets.chomp

    person = peep.new(name)

    puts "#{PREFIX} phone"
    person.phone = gets.chomp

    puts "#{PREFIX} address"
    person.address = gets.chomp

    puts "#{PREFIX} position"
    person.position = gets.chomp

    puts "#{PREFIX} salary"
    person.salary = gets.chomp

    puts "#{PREFIX} slack"
    person.slack = gets.chomp

    puts "#{PREFIX} github"
    person.github = gets.chomp

    @peep << person

    write
    puts "#{@peep.last.name} has been added, thank you"
  end

  def found(person)
    puts "That is:
      #{person.name}
      #{person.phone}
      #{person.address}
      #{person.position}
      #{person.salary}
      #{person.slack}
      #{person.github}"
  end

  def search_person
    puts "Who are you looking for ?"
    search_person = gets.chomp

    matching_person = @peep.find { |person| person.name == search_person }
    if !matching_person.nil?
      found(matching_person)
    else
      puts "Unable to find #{search_person}, they are officially M.I.A."
    end
  end

  def delete_person
    puts "Who would you like to delete/zap/86?"
    delete_person = gets.chomp

    matching_person = @peep.find { |person| person.name == delete_person }

    for person in @peep
      if !matching_person.nil?
        @peep.delete(matching_person)
        write
        puts "#{delete_person}'s name and information has been removed from our employees database"
        break
      else
        puts "Unable to delete #{delete_person}, they may have been already deleted by someone else"
      end
    end
  end

  def report
    File.open("report.html", "w") do |file|
      output_people = @people

      file.puts people_to_html(output_people)
      puts "Creating report of employees now"
    end
  end

  # For each position (Instructor, Campus Director, etc)
  # The minimum salary.
  # The maximum salary.
  # The average salary.
  # The number of employees for each position
  # The names of each employee in that position

  def cancel_search
    puts "Hope you had fun, come back REAL soon you hear"
    exit
  end
end

menu = Menu.new()
menu.prompt
