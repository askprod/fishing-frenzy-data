import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    data: Array
  }

  connect() {
    this.renderChart()
  }

  renderChart() {
    const data = JSON.parse(this.element.dataset.chartDataValue)

    Highcharts.chart(this.element, {
      chart: {
        type: "line",
        style: { fontFamily: "DogicaPixel" },
        time: { useUTC: true },
      },
      legend: { enabled: false },
      credits: { enabled: false },
      title: { text: null },
      xAxis: {
        type: "datetime",
        tickInterval: 24 * 3600 * 1000,
        labels: {
          formatter: function () {
            return Highcharts.dateFormat("%d/%m/%y", this.value);
          },
          style: {
            fontSize: "0.35rem",
            color: "#666",
          }
        }
      },
      yAxis: [{
        title: {
          text: null
        },
      }],
      tooltip: {
        useHTML: true,
        formatter: function () {
          return `
            <div style="text-align: center; padding: 5px;">
              <div style="font-size: 0.75rem; font-weight: bold; margin-bottom: 5px; display: flex; align-items: center; justify-content: center;">
                <span>${this.y}</span>
                <img src="https://cryptologos.cc/logos/ronin-ron-logo.png" alt="Currency" style="width: 12px; height: 12px; margin-left: 3px; margin-top: -1px;" />
              </div>
              <p class="text-xxs" style="margin: 0;">${Highcharts.dateFormat('%d/%m/%y', this.x)}</p>
            </div>
          `;
        }
      },
      series: [{
        data: data.map(item => ({x: item.date, y: item.floor_price}))
      }]
    });
  }
}
