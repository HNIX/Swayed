import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['select', 'chartContainer'];

  connect() {
    console.log("connected");
    this.selectTarget.addEventListener('change', this.fetchData.bind(this));
  }

  fetchData() {
    console.log("changed");
    const dateRange = this.selectTarget.value;
    const url = this.data.get('url') + '?date_range=' + dateRange;

    fetch(url)
      .then(response => response.text())
      .then(html => {
        const tempElement = document.createElement('div');
        tempElement.innerHTML = html;

        this.chartContainerTargets.forEach((container, index) => {
          container.innerHTML = tempElement.querySelectorAll('.chart-container')[index].innerHTML;
        });
      });
  }
}