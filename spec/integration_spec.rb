require('capybara/rspec')
require('./app')
Capybara.app = Sinatra::Application
set(:show_exceptions, false)

RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM doctors *;")
    DB.exec("DELETE FROM patients *;")
  end
end

describe('adding a new doctor', {:type => :feature}) do
  it('allows a user to click a doctor with name and specialty') do
    visit('/')
    click_link('Add New Doctor')
    fill_in('name', :with =>'Bob')
    fill_in('specialty_id', :with =>'1')
    click_button('Add Doctor')
    expect(page).to have_content('Doctors Here are your doctors: Bob')
  end
end

describe('adding a new patient', {:type => :feature}) do
  it('allows a user to add a patient with name and birthdate') do
    visit('/')
    click_link('Add New Patient')
    fill_in('name', :with =>'Sally')
    fill_in('birthdate', :with =>'05-02-1990')
    fill_in('doctor_id', :with =>'1')
    click_button('Add Patient')
    expect(page).to have_content('Patients Here are your patients: Sally')
  end
end

describe('patients by doctor', {:type => :feature}) do
  it('allows a user to see all patients of specific doctor') do
    doctor = Doctor.new({:name => "Bob", :specialty_id => "1", :id =>nil})
    doctor.save()
    patient = Patient.new({:name => "Sally", :birthdate => "05-02-2017", :doctor_id => doctor.id(), :id => nil})
    patient.save()
    visit('/doctors')
    click_link('Bob')
    expect(page).to have_content('Sally')
  end
end
describe('doctors by specialty', {:type => :feature}) do
  it('allows a user to see all doctoes of specific specialty') do
    specialty = Specialty.new({:name => "physical therapy", :id =>nil})
    specialty.save()
    doctor = Doctor.new({:name => "Bob", :specialty_id => specialty.id(), :id => nil})
    doctor.save()
    visit('/specialties')
    click_link('physical therapy')
    expect(page).to have_content('Bob')
  end
end
