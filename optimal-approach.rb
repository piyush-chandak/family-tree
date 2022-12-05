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
    @mapping = Hash.new # Mapping of relations
  end

  def add_person(_name)
    @people << Person.new(_name)
  end

  def add_relation(_name)
    @relations << Relation.new(_name)
  end

  def connect(_name1, _relation, _name2)
    @mapping[_relation] = Hash.new unless @mapping.key?(_relation)
    relation = @mapping[_relation]
    relation[_name2] = [] unless relation.key?(_name2)
    relation[_name2] << _name1
  end

  def relation_of(_relation, _person)
    return [] unless @mapping.key?(_relation) && @mapping[_relation].key?(_person)
    @mapping[_relation][_person]
  end

  def relation_count(_relation, _person)
    list = relation_of(_relation, _person)
    list.length
  end

  def display_mapping
    p @mapping
  end
end

# Creating FamilyMapping instance
family_mapping = FamilyMapping.new

family_mapping.add_person("B")
family_mapping.add_person("C")
family_mapping.add_person("D")

family_mapping.add_relation("son")
family_mapping.add_relation("father")
family_mapping.add_relation("brother")

family_mapping.connect("A", "father", "B")
family_mapping.connect("B", "son", "A")
family_mapping.connect("C", "brother", "A")
family_mapping.connect("D", "brother", "A")

p family_mapping.relation_count("son", "A") # Expected - 1, Output - 1
p family_mapping.relation_count("son", "B") # Expected - 0, Output - 0
p family_mapping.relation_count("brother", "A") # Expected - 2, Output - 2

p family_mapping.relation_count("father", "A") # Expected - 0, Output - 0
p family_mapping.relation_count("father", "B") # Expected - 1, Output - 1

p family_mapping.relation_of("son", "A") # Expected - ["B"], Output - ["B"]
p family_mapping.relation_of("son", "B") # Expected - [], Output - []

p family_mapping.relation_of("father", "A") # Expected - [], Output - []
p family_mapping.relation_of("father", "B") # Expected - ["A"], Output - ["A"]

p family_mapping.relation_of("brother", "A") # Expected - ["C", "D"], Output - ["C", "D"]

# Details
# We have Person and Relation class which contains unique id and name. In future we can add more variables inside it
# FamilyMapping class is main base class which holds all people, relations and mapping of person with another person via relation
# - people - It is instance variable holding all person object
# - relations - It is instance variable holding all relation object
# - mapping - It is hash map holding all relation mapping with person
# - add_person() - It takes name of person and add it into people array
# - add_relation() - It takes name of relation and add it into relation array
# - connect() - It takes person names and relation and map there relation in mapping array
# - relation_of() - It takes person name and relation and find all the maped person connected to it via that relation
# - relation_count() - It takes person name and relation and find the count of maped person connected to it via that relation
# - display_mapping() - It will display how person are connected 

# Space complexity - N
# Time Complexity
#   - add_person - O(1)
#   - add_relation - O(1)
#   - connect - O(1)
#   - relation_of - O(1)
#   - relation_count - O(1)
