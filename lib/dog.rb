class Dog

  attr_accessor :id, :name, :breed

  def initialize(attributes)
    #id: nil, name:, breed:
    attributes.each {|key, value| self.send(("#{key}="), value)}
    self.id ||= nil
  end

  def self.create_table
  sql = <<-SQL
    CREATE TABLE IF NOT EXISTS dogs (
      id INTEGER PRIMARY KEY,
      name TEXT,
      breed TEXT
    )
  SQL
  DB[:conn].execute(sql)
end

def self.drop_table
   DB[:conn].execute("DROP TABLE IF EXISTS dogs")
 end

 def save
    # if self.id
    #   self.update
    # else
      sql = <<-SQL
        INSERT INTO dogs (name, breed)
        VALUES (?,?)
      SQL

      DB[:conn].execute(sql, self.name, self.breed)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
    #end
    self
  end


def self.create(hash)
   dog = self.new(hash)
   dog.save
   dog
 end

 def self.new_from_db(row)
   id = row[0]
   name = row[1]
   breed = row[2]
   self.new(id, name, breed)
 end


 def self.find_by_name(name:)
  sql = "SELECT * FROM dogs WHERE name = ?"
  DB[:conn].execute(sql, name).map { |row| new_from_db(row) }.first
end

 def update
  sql = "UPDATE dogs SET name = ?, breed = ? WHERE id = ?"
  DB[:conn].execute(sql, self.name, self.breed, self.id)
end

end
