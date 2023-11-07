import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['field', 'toggle', 'enabled', 'disabled']


  change(event) {
    this.fieldTarget.classList.toggle('bg-gray-200')
    this.fieldTarget.classList.toggle('bg-indigo-600')

    this.toggleTarget.classList.toggle('translate-x-0')
    this.toggleTarget.classList.toggle('translate-x-5')

    this.enabledTarget.classList.toggle('opacity-0')
    this.enabledTarget.classList.toggle('duration-100')
    this.enabledTarget.classList.toggle('ease-out')

    this.enabledTarget.classList.toggle('opacity-100')
    this.enabledTarget.classList.toggle('duration-200')
    this.enabledTarget.classList.toggle('ease-in')

    this.disabledTarget.classList.toggle('opacity-100')
    this.disabledTarget.classList.toggle('duration-200')
    this.disabledTarget.classList.toggle('ease-in')

    this.disabledTarget.classList.toggle('opacity-0')
    this.disabledTarget.classList.toggle('duration-100')
    this.disabledTarget.classList.toggle('ease-out')
    
  }

  
}