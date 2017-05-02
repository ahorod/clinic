class Patient
  attr_reader(:name, :birthdate, :doctor_id, :id)

  define_method(:initialize) do |attributes|
    @name = attributes.fetch(:name)
    @birthdate = attributes.fetch(:birthdate)
    @doctor_id  = attributes.fetch(:doctor_id)
    @id = attributes.fetch(:id)
  end

  define_singleton_method(:all) do
    returned_patients = DB.exec("SELECT * FROM patients;")
    patients = []
    returned_patients.each() do |patient|
      name = patient.fetch("name")
      birthdate = patient.fetch("birthdate")
      doctor_id = patient.fetch("doctor_id").to_i() # The information comes out of the database as a string.
      id = patient.fetch("id").to_i()
      patients.push(Patient.new({:name => name, :birthdate => birthdate, :doctor_id => doctor_id, :id => id}))
    end
    patients
  end

  define_method(:save) do
    DB.exec("INSERT INTO patients (name, birthdate, doctor_id) VALUES ('#{@name}', '#{@birthdate}', '#{@doctor_id}') RETURNING id;")
  end

  define_method(:==) do |another_patient|
    self.name().==(another_patient.name()).&(self.doctor_id().==(another_patient.doctor_id()))
  end
end
