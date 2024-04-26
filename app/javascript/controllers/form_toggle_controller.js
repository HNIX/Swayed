import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["toggleable", "hideable", "fields", "default", "listValue", "fieldGroup", "dataType"]

  toggleElement(event) {
    const selectedValue = event.target.value;
    this.resetFields();

    this.toggleableTargets.forEach((element) => {
      const showForValues = element.dataset.showFor.split(' ');

      if(showForValues.includes(selectedValue)) {
        element.classList.remove('hidden');
      } else {
        element.classList.add('hidden');
      }
    });
  }

  toggleFieldGroup(event) {
    this.fieldGroupTargets.forEach((element) => {
      
      if(element.dataset.fieldGroup === event.target.value) {
        element.classList.remove('hidden');
      } else {
        element.classList.add('hidden');
      }

    });
  }

  resetFields() {
    this.hideableTargets.forEach((element) => {
      element.classList.add('hidden');
    });

    this.fieldsTargets.forEach((element) => {
      element.value = '';
    });

    this.selectDefaultOption();
  }

  selectDefaultOption() {
    this.defaultTarget.checked = true;
  }
 
}