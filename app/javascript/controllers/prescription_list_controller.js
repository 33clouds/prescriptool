import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="prescription-list"
export default class extends Controller {
  static targets = ["card"]

  connect() {
    this.selectedCard = null;
  }

  toggle(event) {
    const p = event.currentTarget;

    if (this.selectedCard)
      this.selectedCard.classList.remove("expand");

    if (this.selectedCard === p)
      this.selectedCard = null;
    else {
      p.classList.add("expand");
      this.selectedCard = p;
    }
  }
}
