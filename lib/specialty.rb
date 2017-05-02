class Specialty
  attr_reader(:name, :id)

  define_method(:initialize) do |attributes|
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id)
  end

  define_singleton_method(:all) do
    returned_specialties = DB.exec("SELECT * FROM specialties;")
    specialties = []
    returned_specialties.each() do |specialty|
      name = specialty.fetch("name")
      id = specialty.fetch("id").to_i()
      # list_id = task.fetch("list_id").to_i() # The information comes out of the database as a string.
      specialties.push(Specialty.new({:name => name, :id => id}))
    end
    specialties
  end

  define_method(:save) do
    result = DB.exec("INSERT INTO specialties (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first().fetch("id").to_i()
  end

  define_method(:==) do |another_specialty|
    self.name().==(another_specialty.name()).&(self.id().==(another_specialty.id()))
  end

  define_method(:doctors) do
     specialty_doctors = []
     doctors = DB.exec("SELECT * FROM doctors WHERE specialty_id = #{self.id()};")
     doctors.each() do |doctor|
       name = doctor.fetch("name")
       birthdate = doctor.fetch("birthdate")
       specialty_id = doctor.fetch("specialty_id").to_i()
       specialty_doctors.push(Doctor.new({:name => name, :specialty_id => specialty_id, :id => id}))
     end
     specialty_doctors
   end
end
