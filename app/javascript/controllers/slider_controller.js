import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "card"];

  slideLeft() {
    console.log("slideLeft");
    const lastCard = this.cardTargets.pop();
    this.cardTargets.unshift(lastCard);
    this.updateCardOrder();
  }

  slideRight() {
    console.log("slideRight");

    const firstCard = this.cardTargets.shift();
    this.cardTargets.push(firstCard);
    this.updateCardOrder();
  }

  updateCardOrder() {
    this.cardTargets.forEach((card, index) => {
      card.style.order = index;
    });
  }
}