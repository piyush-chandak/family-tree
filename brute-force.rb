class Person
  @@id = 0 # Global instance

  attr_reader :id, :name # Instance variable

  def initialize(_name) # Parameterised constructore
    @@id += 1
    @id = @@id
    @name = _name
  end
end

class Relation
  @@id = 0 # Global instance

  attr_reader :id, :name # Instance variable

  def initialize(_name) # Parameterised constructore
    @@id += 1
    @id = @@id
    @name = _name
  end
end

class FamilyMapping
  def initialize # Default constructor
    @people = [] # List of all person
    @relations = [] # List of all relations
    @mapping = [] # Mapping of person and relation
  end

  def add_person(_name)
    @people << Person.new(_name)

    @mapping.each do |row| # creating new column
      row << nil
    end

    @mapping << Array.new(@people.length) # creating new row
  end

  def add_relation(_name)
    @relations << Relation.new(_name)
  end

  def connect(_name1, _relation, _name2)
    person1 = find_person(_name1) # to get person object from name
    person2 = find_person(_name2) # to get person object from name

    relation = find_relation(_relation) # to get relation object from relation name

    @mapping[person2.id - 1][person1.id - 1] = relation.id # Mapping relation to matrix
  rescue StandardError => e
    raise e
  end

  def relation_of(_relation, _person)
    relation = find_relation(_relation)
    person = find_person(_person)

    mapping_relation = @mapping[person.id - 1]
    filter = []
    mapping_relation.each_with_index do |rel, _index|
      if rel === relation.id
        parent = find_person_by_id(_index + 1) # id start from 1 and array from 0
        filter << parent.name
      end
    end
    filter
  rescue StandardError => e
    raise e
  end

  def relation_count(_relation, _person)
    list = relation_of(_relation, _person)
    list.length
  end

  def display_mapping
    p @mapping
  end

  private
  def find_person(_name)
    person = @people.find {|person| person.name == _name }
    raise "Person Not Found" if person.nil?
    person
  end

  def find_person_by_id(id)
    person = @people.find {|person| person.id == id }
    raise "Person Not Found" if person.nil?
    person
  end

  def find_relation(_name)
    relation = @relations.find {|rel| rel.name == _name }
    raise "Relation Not Found" if relation.nil?
    relation
  end
end

# Creating Person
familyMapping = FamilyMapping.new

familyMapping.add_person("A")
familyMapping.add_person("B")
familyMapping.add_person("C")
familyMapping.add_person("D")

familyMapping.add_relation("son")
familyMapping.add_relation("father")
familyMapping.add_relation("brother")

familyMapping.connect("A", "father", "B")
familyMapping.connect("B", "son", "A")
familyMapping.connect("C", "brother", "A")
familyMapping.connect("D", "brother", "A")

familyMapping.display_mapping

p familyMapping.relation_count("son", "A") # Expected - 1, Output - 1
p familyMapping.relation_count("son", "B") # Expected - 0, Output - 0
p familyMapping.relation_count("brother", "A") # Expected - 2, Output - 2

p familyMapping.relation_count("father", "A") # Expected - 0, Output - 0
p familyMapping.relation_count("father", "B") # Expected - 1, Output - 1

p familyMapping.relation_of("son", "A") # Expected - ["B"], Output - ["B"]
p familyMapping.relation_of("son", "B") # Expected - [], Output - []

p familyMapping.relation_of("father", "A") # Expected - [], Output - []
p familyMapping.relation_of("father", "B") # Expected - ["A"], Output - ["A"]

p familyMapping.relation_of("brother", "A") # Expected - ["C", "D"], Output - ["C", "D"]

# Details
# We have Person and Relation class which contains unique id and name. In future we can add more variables inside it
# FamilyMapping class is main base class which holds all people, relations and mapping of person with another person via relation
# - people - It is instance variable holding all person object
# - relations - It is instance variable holding all relation object
# - mapping - It is 2d array holding all people and there relation
# - add_person() - It takes name of person and add it into people array
# - add_relation() - It takes name of relation and add it into relation array
# - connect() - It takes person names and relation and map there relation in mapping array
# - relation_of() - It takes person name and relation and find all the maped person connected to it via that relation
# - relation_count() - It takes person name and relation and find the count of maped person connected to it via that relation
# - display_mapping() - It will display how person are connected 
# - find_person() - It is private method to find person object on basis of name
# - find_person_by_id() - It is private method to find person object on basis of id
# - find_relation() - It is private method to find relation object on basis of name

# Space complexity - N^2
# Time Complexity
#   - add_person - O(N)
#   - add_relation - O(1)
#   - connect - O(1) if ignore finding of person and relation else O(N)
#   - relation_of - O(N)
#   - relation_count - O(N)
