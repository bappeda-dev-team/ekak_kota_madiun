import { Controller } from "stimulus";


export default class extends Controller {

  renaksiUpdateEvent(event) {
    const bulan = event.params.bulan

    const custom_event = new CustomEvent('update-renaksi', {
      detail: { bulan: bulan },
    });
    setTimeout(() => {
      document.dispatchEvent(custom_event);
    }, 0)
  }

  refreshTotals(event) {
    const bulan = event.detail.bulan

    // Recalculate all totals here
    this.updateTotalAksiBulan(bulan)
    this.updateTotalJumlahTarget()
  }

  updateTotalAksiBulan(bulan) {
    const aksiBulans = document.querySelectorAll(`span.aksi-bulan-${bulan}`)

    const jumlahAksiArray = [];

    aksiBulans.forEach(span => {
      const jumlahAksi = span.getAttribute('data-jumlah-aksi');

      if (jumlahAksi && jumlahAksi !== '+') {
        jumlahAksiArray.push(Number(jumlahAksi));
      }
    });

    // Sum the array
    const totalJumlahAksi = jumlahAksiArray.reduce((sum, value) => sum + value, 0);

    const target = document.getElementById(`total-aksi-bulan-${bulan}`)
    target.innerHTML = totalJumlahAksi
  }

  updateTotalJumlahTarget() {
    const totalBulans = document.querySelectorAll('td.total-aksi-bulan')

    const jumlahTotalArray = [];

    totalBulans.forEach(td => {
      const total = td.innerHTML
      if (Number(total)) {
        jumlahTotalArray.push(Number(total))
      }
    })

    const totalTarget = jumlahTotalArray.reduce((sum, value) => sum + value, 0)

    const target = document.getElementById('total-jumlah-target')
    target.innerHTML = totalTarget

    this.updateWaktuPelaksanaan(jumlahTotalArray.length)
    this.updateRenaksiChecker(totalTarget)
  }

  updateWaktuPelaksanaan(waktuPelaksanaan) {
    const target = document.getElementById('waktu-pelaksanaan')
    target.innerHTML = waktuPelaksanaan
  }

  updateRenaksiChecker(totalTarget) {
    if (totalTarget == 100) {
      const tandaCentang = "<i class='fa fa-check text-success'></i>"
      const target = document.getElementById('renaksi-checker')
      target.innerHTML = tandaCentang
    }
  }
}
