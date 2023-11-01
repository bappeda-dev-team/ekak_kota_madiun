import { Controller } from 'stimulus'
import ApexCharts from 'apexcharts'

export default class extends Controller {
  static targets = ['first', 'second']
  connect() {
    var standing = new ApexCharts(this.firstTarget, this.standingChart());
    standing.render();
  }

  lineChart() {
    // Line chart
    var optionsLineChart = {
      series: [{
        name: 'Clients',
        data: [120, 160, 200, 470, 420, 150, 470, 750, 650, 190, 140]
      }],
      labels: ['01 Feb', '02 Feb', '03 Feb', '04 Feb', '05 Feb', '06 Feb', '07 Feb', '08 Feb', '09 Feb', '10 Feb', '11 Feb'],
      chart: {
        type: 'area',
        width: "100%",
        height: 360
      },
      theme: {
        monochrome: {
          enabled: true,
          color: '#31316A',
        }
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
      },
    };

    return optionsLineChart;
  }

  barChart() {
    // Bar Chart
    var optionsBarChart = {
      series: [{
        name: 'Sales',
        data: [34, 29, 32, 38, 39, 35, 36]
      }],
      chart: {
        type: 'bar',
        width: "100%",
        height: 360
      },
      theme: {
        monochrome: {
          enabled: true,
          color: '#31316A',
        }
      },
      plotOptions: {
        bar: {
          columnWidth: '25%',
          borderRadius: 5,
          radiusOnLastStackedBar: true,
          colors: {
            backgroundBarColors: ['#F2F4F6', '#F2F4F6', '#F2F4F6', '#F2F4F6'],
            backgroundBarRadius: 5,
          },
        }
      },
      labels: [1, 2, 3, 4, 5, 6, 7],
      xaxis: {
        categories: ['01 Feb', '02 Feb', '03 Feb', '04 Feb', '05 Feb', '06 Feb', '07 Feb'],
        crosshairs: {
          width: 1
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
            return "$ " + val + "k"
          }
        }
      },
    };

    var barChart = new ApexCharts(this.element, optionsBarChart);
    barChart.render();
  }

  standingChart() {
    var optionsTrafficShareChart = {
      series: [{
        name: 'Visits',
        data: [4, 7, 9, 29, 51]
      }],
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
      xaxis: {
        categories: ['Mail', 'Social', 'Organic', 'Referrals', 'Direct'],
        labels: {
          style: {
            fontSize: '12px',
            fontWeight: 500,
          },
          offsetY: 5
        },
        axisBorder: {
          color: '#ffffff',
        },
        axisTicks: {
          color: '#ffffff',
          offsetY: 5
        },
      }
    };

    return optionsTrafficShareChart;
  }
}
