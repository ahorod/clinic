require('sinatra')
require('sinatra/reloader')
require('./lib/patient')
require('./lib/doctor')
also_reload('lib/**/*.rb')
require("pg")
require('pry')

DB = PG.connect({:dbname => 'clinic'})

get("/") do
  erb(:index)
end

get("/doctors/new") do
  erb(:doctor_form)
end

post("/doctors") do

  name = params.fetch("name")
  specialty = params.fetch("specialty")
  doctor = Doctor.new({:name => name, :specialty => specialty, :id => nil})
  doctor.save()
  @doctors = Doctor.all()
  # binding.pry
  erb(:doctors)
 end

 get('/doctors') do
   @doctors = Doctor.all()
   erb(:doctors)
 end

 get("/patients/new") do
   erb(:patient_form)
 end

 post("/patients") do
   name = params.fetch("name")
   birthdate = params.fetch("birthdate")
   doctor_id = params.fetch("doctor_id")
   patient = Patient.new({:name => name, :birthdate => birthdate, :doctor_id => doctor_id, :id => nil})
   patient.save()
   @patients = Patient.all()
  #  binding.pry
   erb(:patients)
  end

  get('/patients') do
    @patients = Patient.all()
    erb(:patients)
  end

  get('/doctors/:id') do
  @doctor = Doctor.find(params.fetch('id').to_i())

  # @patients = @doctor.patients()
  # binding.pry
  erb(:doctor)
end
