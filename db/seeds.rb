# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Lembaga.destroy_all
Pajak.destroy_all
Lembaga.create(nama_lembaga: 'Kota Madiun', tahun: '2021')
Pajak.create(tahun: "2021", tipe: "Tanpa Pajak", potongan: 0)
Pajak.create(tahun: "2021", tipe: "PPN", potongan: 0.1)