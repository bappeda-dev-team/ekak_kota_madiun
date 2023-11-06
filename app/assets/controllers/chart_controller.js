import { Controller } from 'stimulus'
import ApexCharts from 'apexcharts'

export default class extends Controller {
  static targets = ['opd', 'opds']
  static values = {
    opd: String,
    url: String,
    tahun: String
  }

  changeOpd(event) {
    const { id } = event.detail.data
    const url = '/api/opd/perbandingan_pagu'
    let formData = new FormData();
    formData.append('kode_opd', id);
    formData.append('tahun', this.tahunValue);

    this.chartUpdate(url, formData)
  }

  async chartUpdate(url, formData) {
    const chart = ApexCharts.getChartByID('opd')
    chart.resetSeries()

    const data = await this.fetcher(url, formData)
    const pagu_kak = data.subkegiatan_opd.map((val) => {
      let pagu = Math.floor(val.pagu_kak / 1000_000)
      let pagu_sipd = Math.floor(val.pagu_sipd / 1000_000)
      return (
        {
          x: val.nama_subkegiatan,
          y: pagu,
          goals: [
            {
              name: 'Target',
              value: pagu_sipd,
              strokeHeight: 2,
              strokeColor: '#775DD0'
            }
          ]
        }
      )
    })
    const pagu_sipd = data.subkegiatan_opd.map((val) => {
      let pagu = Math.floor(val.pagu_sipd / 1000_000)
      return (
        {
          x: val.nama_subkegiatan,
          y: pagu
        }
      )
    })
    chart.updateOptions({
      series: [
        {
          name: 'Pagu KAK',
          data: pagu_kak
        },
        {
          name: 'Pagu SIPD',
          data: pagu_sipd
        }
      ],
      title: {
        text: 'Pagu Subkegiatan ' + data.nama_opd,
        align: 'center',
        floatinig: true
      },
      tooltip: {
        fillSeriesColor: false,
        onDatasetHover: {
          highlightDataSeries: true,
        },
        theme: 'light',
        style: {
          fontSize: '14px',
          fontFamily: 'Inter',
        },
        y: {
          formatter: function (val) {
            const label = val === 0 ? 0 : "Rp." + val + " Juta"
            return label
          }
        },
      },
      xaxis: {
        position: 'bottom',
        labels: {
          show: true,
          rotate: -75,
          rotateAlways: true,
          maxHeight: 250,
          trim: true
        }
      }
    })
  }

  async opdTargetConnected() {
    const options = {
      chart: {
        id: 'opd',
        type: 'bar',
        height: 750,
        foreColor: '#4B5563',
        fontFamily: 'Inter',
        zoom: {
          enabled: true,
          type: 'y',
          autoScaleYaxis: true
        }
      },
      plotOptions: {
        bar: {
          horizontal: true
        }
      },
      series: [],
      noData: {
        text: 'Memuat Data...'
      },
      colors: ['#f34336', '#ff9f31'],
      dataLabels: {
        enabled: false
      },
      title: {
        text: 'Pagu Subkegiatan',
        align: 'center',
        floatinig: true
      },
      subtitle: {
        text: 'Perbandingan Pagu KAK dan Pagu SIPD',
        align: 'center',
        floatinig: true
      },
      tooltip: {
        shared: true,
        intersect: false
      },
      xaxis: {
        tickPlacement: 'on'
      },
    }
    const chart = new ApexCharts(this.opdTarget, options)
    chart.render()

    let formData = new FormData();
    formData.append('kode_opd', this.opdValue);
    formData.append('tahun', this.tahunValue);
    const url = '/api/opd/perbandingan_pagu'

    const data = await this.fetcher(url, formData)
    const pagu_kak = data.subkegiatan_opd.map((val, index) => {
      let pagu = Math.floor(val.pagu_kak / 1000_000)
      let pagu_sipd = Math.floor(val.pagu_sipd / 1000_000)
      const no = index + 1
      return (
        {
          x: `${no} ${val.nama_subkegiatan}`,
          y: pagu,
          goals: [
            {
              name: 'Target',
              value: pagu_sipd,
              strokeHeight: 2,
              strokeColor: '#775DD0'
            }
          ]
        }
      )
    })
    const pagu_sipd = data.subkegiatan_opd.map((val, index) => {
      let pagu = Math.floor(val.pagu_sipd / 1000_000)
      const no = index + 1
      return (
        {
          x: `${no} ${val.nama_subkegiatan}`,
          y: pagu
        }
      )
    })
    chart.updateOptions({
      series: [
        {
          name: 'Pagu KAK',
          data: pagu_kak
        },
        {
          name: 'Pagu SIPD',
          data: pagu_sipd
        }
      ],
      title: {
        text: 'Pagu Subkegiatan ' + data.nama_opd,
        align: 'center',
        floatinig: true
      },
      tooltip: {
        fillSeriesColor: false,
        onDatasetHover: {
          highlightDataSeries: true,
        },
        theme: 'light',
        style: {
          fontSize: '14px',
          fontFamily: 'Inter',
        },
        y: {
          formatter: function (val) {
            const label = val === 0 ? 0 : "Rp." + val + " Juta"
            return label
          }
        },
      },
      xaxis: {
        position: 'bottom',
        labels: {
          show: true,
          rotate: -75,
          rotateAlways: true,
          maxHeight: 250,
          trim: true
        }
      }
    })
  }

  async opdsTargetConnected() {
    const options = {
      chart: {
        type: 'bar',
        height: 750,
        foreColor: '#4B5563',
        fontFamily: 'Inter',
        zoom: {
          enabled: true,
          type: 'y',
          autoScaleYaxis: true
        }
      },
      series: [],
      noData: {
        text: 'Memuat Data...'
      },
      title: {
        text: 'Pagu OPD ' + this.tahunValue,
        align: 'center',
        floatinig: true
      },
      subtitle: {
        text: 'Perbandingan Pagu KAK dan Pagu SIPD',
        align: 'center',
        floatinig: true
      },
      colors: ['#f34336', '#ff9f31'],
      dataLabels: {
        enabled: false
      },
      tooltip: {
        shared: true,
        intersect: false
      },
      xaxis: {
        tickPlacement: 'on'
      }
    }
    const chart = new ApexCharts(this.opdsTarget, options)
    chart.render()

    // data fetch
    let formData = new FormData();
    formData.append('tahun', this.tahunValue);
    const url = '/api/opd/pagu_all'
    const data = await this.fetcher(url, formData)
    const pagu_kak = data.map((val) => {
      let pagu = Math.floor(val.pagu_kak / 1000_000_000)
      let pagu_sipd = Math.floor(val.pagu_sipd / 1000_000_000)
      return (
        {
          x: val.nama_opd,
          y: pagu,
          goals: [
            {
              name: 'Target',
              value: pagu_sipd,
              strokeHeight: 5,
              strokeColor: '#775DD0'
            }
          ]
        }
      )
    })
    const pagu_sipd = data.map((val) => {
      let pagu = Math.floor(val.pagu_sipd / 1000_000_000)
      return (
        {
          x: val.nama_opd,
          y: pagu
        }
      )
    })
    chart.updateOptions({
      series: [
        {
          name: 'Pagu KAK',
          data: pagu_kak
        },
        {
          name: 'Pagu SIPD',
          data: pagu_sipd
        }
      ],
      tooltip: {
        fillSeriesColor: false,
        onDatasetHover: {
          highlightDataSeries: true,
        },
        theme: 'light',
        style: {
          fontSize: '14px',
          fontFamily: 'Inter',
        },
        y: {
          formatter: function (val) {
            const label = val === 0 ? 0 : "Rp." + val + " M"
            return label
          }
        },
      },
      xaxis: {
        position: 'bottom',
        labels: {
          show: true,
          rotate: -75,
          rotateAlways: true,
          maxHeight: 250,
          trim: true,
        }
      }
    })
  }

  async fetcher(url, formData) {
    const request = await fetch(url,
      {
        body: formData,
        method: "post",
      })
    const response = await request.json();
    return response.data;
  }
}
