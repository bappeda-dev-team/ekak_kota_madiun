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
        height: 450,
      },
      plotOptions: {
        bar: {
          horizontal: true,
          dataLabels: {
            position: 'top'
          }
        }
      },
      dataLabels: {
        enabled: true,
        offsetX: -20,
        style: {
          fontSize: '12px',
          colors: ['#fff']
        }
      },
      series: [],
      colors: ['#f34336', '#ff9f31'],
      noData: {
        text: 'Loading...'
      },
      xaxis: {
        type: 'category'
      },
      tooltip: {
        shared: true,
        followCursor: true,
        intersect: false,
      },
    }
    return options;
  }

  async opdTargetConnected() {
    const chart = new ApexCharts(this.opdTarget, this.baseChart())
    chart.render()

    let formData = new FormData();
    formData.append('kode_opd', this.opdValue);
    formData.append('tahun', '2023_perubahan');
    const url = '/api/opd/perbandingan_pagu'

    const data = await this.fetcher(url, formData)
    const series = [
      {
        name: 'Pagu KAK',
        data: [
          {
            x: data.nama_opd,
            y: data.pagu_kak,
          },
        ]
      },
      {
        name: 'Pagu SIPD',
        data: [
          {
            x: data.nama_opd,
            y: data.pagu_sipd
          },
        ]
      }

    ]
    chart.updateSeries(series)
  }

  async opdsTargetConnected() {
    const options = {
      chart: {
        type: 'bar',
        height: 500,
        foreColor: '#4B5563',
        fontFamily: 'Inter',
      },
      series: [],
      noData: {
        text: 'Memuat Data...'
      },
      dataLabels: {
        enabled: false
      },
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
      return (
        {
          x: val.nama_opd,
          y: pagu
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
      xaxis: {
        position: 'bottom'
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
