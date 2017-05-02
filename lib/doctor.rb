class Doctor
  attr_reader(:name, :specialty_id, :id)

  define_method(:initialize) do |attributes|
    @name = attributes.fetch(:name)
    @specialty_id = attributes.fetch(:specialty_id)
    @id = attributes.fetch(:id)
  end

  define_singleton_method(:all) do
    returned_doctors =  DB.exec("SELECT * FROM doctors;")
    doctors = []
    returned_doctors.each() do |doctor|
      name = doctor.fetch("name")
      specialty_id = doctor.fetch("specialty_id")
      id = doctor.fetch("id").to_i()
      doctors.push(Doctor.new({:name => name, :specialty_id => specialty_id, :id => id}))
    end
    doctors
  end

# without making a new table it would be something like this:
  # define_singleton_method(:select_specialty_id) do
  #   the_specialty_id = params.fetch("specialty_id_to_find")
  #   returned_doctors = DB.exec("SELECT * FROM doctors WHERE specialty_id = #{the_specialty_id}")
  # end

  define_method(:save) do
    result = DB.exec("INSERT INTO doctors (name, specialty_id) VALUES ('#{@name}', '#{@specialty_id}') RETURNING id;")
    @id = result.first().fetch("id").to_i
  end

  define_method(:==) do |another_doctor|
    self.name().==(another_doctor.name()).&(self.id().==(another_doctor.id()))
  end

  define_singleton_method(:find) do |id|
   found_doctor = nil
   Doctor.all().each() do |doctor|
     if doctor.id().==(id)
       found_doctor = doctor
     end
   end
   found_doctor
 end

 define_method(:patients) do
    doctor_patients = []
    patients = DB.exec("SELECT * FROM patients WHERE doctor_id = #{self.id()};")
    patients.each() do |patient|
      name = patient.fetch("name")
      birthdate = patient.fetch("birthdate")
      doctor_id = patient.fetch("doctor_id").to_i()
      doctor_patients.push(Patient.new({:name => name, :birthdate => birthdate, :doctor_id => doctor_id, :id => id}))
    end
    doctor_patients
  end

end
