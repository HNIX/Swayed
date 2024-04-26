import { Controller } from "@hotwired/stimulus"
import Rails from "@rails/ujs";

export default class extends Controller {
  static targets = ["input", "feedback"];
  static values = { campaignId: Number }

  validate() {
    const formula = this.inputTarget.value;
    const campaignId = this.campaignIdValue;

    const url = `/campaigns/${campaignId}/validate_formula`;

    Rails.ajax({
      url: url,
      type: "POST",
      dataType: 'json',
      data: `formula=${encodeURIComponent(formula)}&campaign_id=${campaignId}`,
      success: (data) => this.handleResponse(data),
      error: (error) => console.error('Error:', error)
    });
  }

  handleResponse(data) {
    if (data.valid) {
      this.feedbackTarget.textContent = `Formula is valid. Evaluated value: ${data.evaluated_value}`;
      this.feedbackTarget.classList.add('text-green-500');
      this.feedbackTarget.classList.remove('text-red-500');
    } else {
      this.feedbackTarget.textContent = `Invalid formula: ${data.error} ${data.formula}`;
      this.feedbackTarget.classList.add('text-red-500');
      this.feedbackTarget.classList.remove('text-green-500');
    }
  }

}

