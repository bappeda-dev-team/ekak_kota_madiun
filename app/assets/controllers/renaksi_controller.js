import { Controller } from "stimulus";


export default class extends Controller {

  refreshTotals(event) {
    const bulan = event.params.bulan
    console.log('bulan: ', bulan)

    // Recalculate all totals here
    this.updateTotalAksiBulan(bulan)
    this.updateTotalJumlahTarget()
    this.updateWaktuPelaksanaan()
  }

  updateTotalAksiBulan(bulan) {
    const target = document.getElementById(`total-aksi-bulan-${bulan}`)
    target.innerHTML = 999
  }

  updateTotalJumlahTarget() {
    const target = document.getElementById('total-jumlah-target')
    target.innerHTML = 8888
  }

  updateWaktuPelaksanaan() {
    const target = document.getElementById('waktu-pelaksanaan')
    target.innerHTML = 7777
  }
}
