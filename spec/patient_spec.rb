require('rspec')
require('pg')
require('patient')

DB = PG.connect({:dbname => 'clinic_test'})

RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM patients *;")
  end
end

describe(Patient) do


  describe(".all") do
    it("is empty at first") do
      test_patient = Patient.new({:name => "Sally", :birthdate => "05-02-2017", :doctor_id => 1, :id => nil})
      expect(Patient.all()).to(eq([]))
    end
  end

  describe("#save") do
    it("adds a patient to the array of saved patients") do
      test_patient = Patient.new({:name => "Sally", :birthdate => "05-02-2017", :doctor_id => 1, :id => nil})
      test_patient.save()
      expect(Patient.all()).to(eq([test_patient]))
    end
  end

  describe("#name") do
    it("lets you read the name out") do
    test_patient = Patient.new({:name => "Sally", :birthdate => "05-02-2017", :doctor_id => 1, :id => nil})
      expect(test_patient.name()).to(eq("Sally"))
    end
  end

  describe("#birthdate") do
    it("lets you read the birthdate out") do
      test_patient = Patient.new({:name => "Sally", :birthdate => "05-02-2017", :doctor_id => 1, :id => nil})
      expect(test_patient.name()).to(eq("Sally"))
    end
  end

  describe("#doctor_id") do
    it("lets you read the doctor ID out") do
      test_patient = Patient.new({:name => "Sally", :birthdate => "05-02-2017", :doctor_id => 1, :id => nil})
      expect(test_patient.doctor_id()).to(eq(1))
    end
  end

  describe("#==") do
    it("is the same patient if it has the same name and doctor ID") do
      patient1 = Patient.new({:name => "Sally", :birthdate => "05-02-2017", :doctor_id => 1, :id => nil})
      patient2 = Patient.new({:name => "Sally", :birthdate => "05-02-2017", :doctor_id => 1, :id => nil})
      expect(patient1).to(eq(patient2))
    end
  end
end
