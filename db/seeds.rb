# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
User.destroy_all
Med.destroy_all
Prescription.destroy_all
MedsPrescription.destroy_all

julie = User.new(first_name: "Julie", last_name: "Filstroff", email: "julie@gmail.com", password: "123456", pro: true)
rodrigo = User.new(first_name: "Rodrigo", last_name: "Borges", email: "rodrigo@gmail.com", password: "123456")
rodrigo.save!
julie.save!
paracetamol = Med.new(name: "Paracetamol")
paracetamol.save!
p = Prescription.new
p.patient = rodrigo
p.professional = julie
med_presc = MedsPrescription.new(dosage: "1 every morning")
med_presc.med = paracetamol
med_presc.prescription = p
p.save!
