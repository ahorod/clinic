require('rspec')
require('pg')
require('doctor')

DB = PG.connect({:dbname => 'clinic_test'})

RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM doctors *;")
  end
end

describe(Doctor) do
  describe(".all") do
    it("starts off with no doctors") do
      expect(Doctor.all()).to(eq([]))
    end
  end

  describe("#name") do
    it("tells you its name") do
      doctor = Doctor.new({:name => "Bob", :specialty => "family doctor", :id => nil})
      expect(doctor.name()).to(eq("Bob"))
    end
  end

  describe("#specialty") do
    it("tells you its specialty") do
      doctor = Doctor.new({:name => "Bob", :specialty => "family doctor", :id => nil})
      expect(doctor.specialty()).to(eq("family doctor"))
    end
  end

  describe("#id") do
    it("sets its ID when you save it") do
      doctor = Doctor.new({:name => "Bob", :specialty => "family doctor", :id => nil})
      doctor.save()
      expect(doctor.id()).to(be_an_instance_of(Fixnum))
    end
  end

  describe("#save") do
    it("lets you save doctors to the database") do
      doctor = Doctor.new({:name => "Bob", :specialty => "family doctor", :id => nil})
      doctor.save()
      expect(Doctor.all()).to(eq([doctor]))
    end
  end

  describe("#==") do
    it("is the same doctor if it has the same name") do
      doctor1 = Doctor.new({:name => "Bob", :specialty => "family doctor", :id => nil})
      doctor2 = Doctor.new({:name => "Bob", :specialty => "family doctor", :id => nil})
      expect(doctor1).to(eq(doctor2))
    end
  end
end
