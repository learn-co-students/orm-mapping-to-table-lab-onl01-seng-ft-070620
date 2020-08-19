class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]  
  
  attr_accessor :name, :grade
  attr_reader :id
  
  def initialize(id = nil, name, grade)
    @name = name
    @grade = grade
    @id = id
  end
  
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE students (ID INTEGER PRIMARY KEY, NAME TEXT, GRADE TEXT);
    SQL
    DB[:conn].execute(sql)
  end
  
  def self.drop_table
    sql = <<-SQL
    DROP TABLE students;
    SQL
    DB[:conn].execute(sql)
  end
  
  def save
    sql = <<-SQL
    INSERT INTO students (NAME, GRADE) values(?,?);
    SQL
    DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute("SELECT MAX(ID) AS LastID FROM students")[0][0]
  end
  
  def self.create(name:, grade:)
    student = Student.new(name, grade)
    student.save
    student
  end
end
