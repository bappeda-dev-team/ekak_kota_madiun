# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Lembaga.destroy_all
Pajak.destroy_all
Opd.destroy_all
User.destroy_all

lembaga = Lembaga.create(nama_lembaga: "Kota Madiun", tahun: "2022")
Pajak.create(tahun: "2022", tipe: "Tanpa Pajak", potongan: 0)
Pajak.create(tahun: "2022", tipe: "PPN", potongan: 0.1)
opd = Opd.create(nama_opd: "Sekretariat DPRD", kode_opd: "12345", lembaga_id: lembaga.id)
User.create(nama: "Deddy Purnomo", nik: "197609141996021002", kode_opd: opd.kode_opd, email: "test@test.com", password: "123456")
# Sample seed for anggaran
# Root category
# root = Category.create name: 'sport'
# # Sport subcategories
# basketball_cat = root.children.create name: 'basketball'
# fitness_cat = root.children.create name: 'fitness'
# # Basketball categories
# basketball_cat.children.create name: 'clothing'
# basketball_cat.children.create name: 'basketballs'
# basketball_cat.children.create name: 'footwear'
# # Fitness subcategories
# fitness_cat.children.create name: 'dumbbells'
# fitness_cat.children.create name: 'benches'
# fitness_cat.children.create name: 'kettlebells'
