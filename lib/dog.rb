class Dog

  attr_accessor :id, :name, :breed

  def initialize(keywords)
    # @name = name
    # @breed = breed
    # @id = id

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
    if self.id
      self.update
    else
      sql = <<-SQL
        INSERT INTO dogs (name, breed)
        VALUES (?,?)
      SQL

      DB[:conn].execute(sql, self.name, self.breed)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
    end
  end


def self.create(name, breed)
   dog = self.new(name, breed)
   dog.save
   dog
 end


 def self.find_by_name(:name)
  sql = "SELECT * FROM dogs WHERE name = ?"
  DB[:conn].execute(sql, name).map { |row| new_from_db(row) }.first
end

 def update
  sql = "UPDATE dogs SET name = ?, breed = ? WHERE id = ?"
  DB[:conn].execute(sql, self.name, self.breed, self.id)
end

end
