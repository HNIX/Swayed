import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "message"];

  validate() {
    const inputValue = this.inputTarget.value;
    try {
      JSON.parse(inputValue);
      this.messageTarget.textContent = "Valid JSON";
      this.messageTarget.classList.add("text-green-500");
      this.messageTarget.classList.remove("text-red-500");
    } catch (error) {
      this.messageTarget.textContent = "Invalid JSON";
      this.messageTarget.classList.add("text-red-500");
      this.messageTarget.classList.remove("text-green-500");
    }
  }
}
