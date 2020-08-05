class Student
  attr_reader :id
  attr_accessor :name, :grade
  
  def initialize(name, grade, id = nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql = "
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
      );
      "
      DB[:conn].execute(sql)
  end
  
  def self.drop_table
    sql = "
      DROP TABLE IF EXISTS students
      "
      DB[:conn].execute(sql)
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?,?);
      SQL
      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end

  def self.create(attr)
      new_student = Student.new(attr[:name], attr[:grade], attr[:id])
      new_student.save
      new_student
  end

end
