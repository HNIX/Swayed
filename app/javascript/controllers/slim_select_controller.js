import SlimSelect from 'slim-select'
import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="slim-select"
export default class extends Controller {
    connect() {
        this.select = new SlimSelect({
          select: this.element
        })
      }
      disconnect() {
        this.select.destroy()
      }
  }