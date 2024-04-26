import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["field", "operator", "fieldset", "select"]

  connect() {
    //this.updateOperators();
  }

  updateOperators() {
    const fieldId = this.fieldTarget.value;
    const campaignId = this.fieldTarget.dataset.campaignId;
    
    if (!fieldId) return;

    console.log("fetch operators");

    fetch(`/campaigns/${campaignId}/fields/${fieldId}`)
      .then(response => response.json())
      .then(operatorOptions => {
        this.populateOperators(operatorOptions);
      })
      .catch(error => console.error("Error fetching operator options:", error));
  }

  populateOperators(operatorOptions) {
    let optionsHtml = Object.entries(operatorOptions).map(([value, label]) => {
      return `<option value="${value}">${label}</option>`;
    }).join("");

    this.operatorTarget.innerHTML = optionsHtml;
  }

  toggleFieldset(event) {
    const fieldset = this.fieldsetTarget;
    const checked = event.target.checked;

    if (checked) {
      fieldset.classList.add("hidden");
      this.clearSelection();
    } else {
      fieldset.classList.remove("hidden");
    }
  }

  clearSelection() {
    const selectBox = this.selectTarget;
    Array.from(selectBox.options).forEach(option => option.selected = false);
  }

}