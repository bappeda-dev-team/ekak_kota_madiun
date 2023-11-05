import { Controller } from 'stimulus'
import ApexCharts from 'apexcharts'

export default class extends Controller {
  static targets = ['opd', 'opds', 'subkegiatans']
  static values = {
    opd: String,
    url: String
  }

  baseChart() {
    const options = {
      chart: {
        type: 'bar',
        height: 650,
        foreColor: '#4B5563',
        fontFamily: 'Inter',
      },
      series: [],
      colors: ['#f34336', '#ff9f31'],
      noData: {
        text: 'Memuat Data...'
      },
      plotOptions: {
        bar: {
          barHeight: '100%',
          horizontal: true,
          columnWdith: '90%'
        }
      },
      dataLabels: {
        enabled: false,
      },
      tooltip: {
        shared: true,
        followCursor: true,
        intersect: false,
      },
      title: {
        text: 'Pagu Subkegiatan',
        align: 'center',
        floatinig: true
      }
    }
    return options;
  }

  async opdTargetConnected() {
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
    formData.append('tahun', '2023_perubahan');
    const url = '/api/opd/perbandingan_pagu'

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
      events: {
        beforeZoom: (e, { yaxis }) => {
          return {
            yaxis: {
              min: 0,
            }
          }
        }
      },
      series: [],
      noData: {
        text: 'Memuat Data...'
      },
      title: {
        text: 'Pagu OPD',
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
    formData.append('tahun', '2023_perubahan');
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
    // chart.updateSeries(newSeries)
  }

  subkegiatansTargetConnected() {
    const chart = new ApexCharts(this.subkegiatansTarget, this.baseChart())
    chart.render()

    this.fetcher(chart)
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

  chartRender() {
    var optionsTrafficShareChart = {
      series: [],
      noData: {
        text: 'Memuat Data...'
      },
      chart: {
        type: 'bar',
        height: 500,
        foreColor: '#4B5563',
        fontFamily: 'Inter',
      },
      plotOptions: {
        bar: {
          horizontal: true,
          distributed: false,
          barHeight: '90%',
          borderRadius: 10,
          colors: {
            backgroundBarColors: ['#fff'],
            backgroundBarOpacity: .2,
            backgroundBarRadius: 10,
          },
        }
      },
      colors: ['#4D4AE8'],
      dataLabels: {
        enabled: true,
        textAnchor: 'middle',
        formatter: function (val, opt) {
          return opt.w.globals.labels[opt.dataPointIndex]
        },
        offsetY: -1,
        dropShadow: {
          enabled: false,
        },
        style: {
          fontSize: '12px',
          fontFamily: 'Inter',
          fontWeight: '500',
        }
      },
      grid: {
        show: false,
        borderColor: '#f2f2f2',
        strokeDashArray: 1,
      },
      legend: {
        show: false,
      },
      yaxis: {
        labels: {
          show: false
        },
      },
      tooltip: {
        fillSeriesColor: false,
        onDatasetHover: {
          highlightDataSeries: false,
        },
        theme: 'light',
        style: {
          fontSize: '12px',
          fontFamily: 'Inter',
        },
        y: {
          formatter: function (val) {
            return val + "%"
          }
        },
      },
    };

    return optionsTrafficShareChart;
  }
}
