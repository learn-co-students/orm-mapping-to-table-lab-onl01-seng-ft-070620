class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade, id = nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql =  <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade INTEGER
        )
        SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql =  <<-SQL
      DROP TABLE students
        SQL
      DB[:conn].execute(sql)
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
    sql = <<-SQL
      SELECT id FROM students WHERE name = ?
    SQL

    @id = DB[:conn].execute(sql, self.name).flatten[0]

  end

  def self.create(students_hash)
    student = Student.new(nil, nil)
    students_hash.each{|key, value| student.send(("#{key}="), value)}
    student.save
    student
  end

end
