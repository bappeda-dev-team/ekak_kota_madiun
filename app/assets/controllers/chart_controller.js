import { Controller } from 'stimulus'
import ApexCharts from 'apexcharts'

export default class extends Controller {
  static targets = ['opds', 'subkegiatans']
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

  opdsTargetConnected() {
    const chart = new ApexCharts(this.opdsTarget, this.baseChart())
    chart.render()

    this.fetcher(chart)
  }

  subkegiatansTargetConnected() {
    const chart = new ApexCharts(this.subkegiatansTarget, this.baseChart())
    chart.render()

    this.fetcher(chart)
  }

  async fetcher(chart) {
    let formData = new FormData();
    formData.append('kode_opd', this.opdValue);
    formData.append('tahun', '2023_perubahan');

    const request = await fetch('/api/opd/perbandingan_pagu',
      {
        body: formData,
        method: "post",
      })
    const response = await request.json();
    const data = response.data
    this.seriesUpdater(data, chart)
  }

  seriesUpdater(data, chart) {
    let testSeries = [
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
    chart.updateSeries(testSeries)
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
