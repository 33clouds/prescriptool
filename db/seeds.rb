# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require "faker"

UsersSpecialty.destroy_all
Specialty.destroy_all
MedsPrescription.destroy_all
Prescription.destroy_all
User.destroy_all
Med.destroy_all

@dosages = ["one pill every morning for one month", "two pills during lunch for two weeks", "one pill before sleeping during six months", "one pill two hours before eating for one week"]
@meds = ["PARACETAMOL", "IBUPROFEN", "ASPIRIN", "ANXIOLITIC", "AMOXICCILIN", "ANTIHISTAMIN", "LOVENOX", "PYOSTACIN"]
@specialties = ["CARDIOLOGIST", "RHEUMATOLOGIST", "RADIOLOGIST", "GP", "OPHTALMOLOGIST", "DERMATOLOGIST"]

User.create!(first_name: "Julie", last_name: "Filstroff", email: "julie@gmail.com", password: "123456", pro: true, address: Faker::Address.full_address)
User.create!(first_name: "Olga", last_name: "Grigoryeva", email: "olga@gmail.com", password: "123456", pro: true, address: Faker::Address.full_address)
User.create!(first_name: "Rodrigo", last_name: "Borges", email: "rodrigo@gmail.com", password: "123456", address: Faker::Address.full_address)
User.create!(first_name: "Kevin", last_name: "Gandolfi", email: "kevin@gmail.com", password: "123456", address: Faker::Address.full_address)

puts "\nCreating users..."
10.times do
  user = User.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.email,
    password: Faker::Internet.password,
    pro: [true, false].sample,
    address: Faker::Address.full_address
  )
  puts "> Created user #{user.inspect}"
end

puts "\nCreating meds..."
@meds.each do |med_text|
  med = Med.create!(name: med_text)
  puts "> Created med #{med.inspect}"
end

puts "\nCreating specialties..."
@specialties.each do |specialty_text|
  specialty = Specialty.create!(name: specialty_text)
  puts "> Created specialty #{specialty.inspect}"
end

puts "\nAssigning specialties to users..."
User.where(pro: true).each do |user|
  user.specialties << Specialty.all.sample
  puts "> Assigned specialties #{user.specialties.map { |s| s.name }} to user #{user.inspect}"
end

puts "\nCreating prescriptions..."
User.where(pro: false).each do |user|
  10.times do
    p = user.prescriptions_as_patient.new
    p.professional = User.where(pro: true).sample
    p.save!

    puts "> Created prescription #{p.inspect}"

    p.meds_prescriptions.create!(
      med: Med.all.sample,
      dosage: @dosages.sample
    )

    puts "> Assigned meds prescription #{p.meds_prescriptions.map(&:id)} to prescription #{p.inspect}"
  end
end
