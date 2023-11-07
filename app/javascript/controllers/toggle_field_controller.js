import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["select", "staticValue"];
  
    connect() {
      this.checkValue();
    }
  
    checkValue() {
      if (this.selectTarget.value === '-1') {
        this.staticValueTarget.classList.remove("hidden");
      } else {
        this.staticValueTarget.classList.add("hidden");
      }
    }
  
    valueChanged() {
      this.checkValue();
    }
  }