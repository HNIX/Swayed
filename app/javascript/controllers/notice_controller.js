// notice_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    connect() {
      setTimeout(this.fadeOut.bind(this), 2000);
    }
  
    fadeOut() {
      this.element.classList.add("opacity-0", "h-0");
      setTimeout(this.hide.bind(this), 1000); // Wait 1 second for the fade effect to complete
    }
  
    hide() {
      this.element.style.display = "none";
    }
  }