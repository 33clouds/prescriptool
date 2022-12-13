import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="prevent-default"
export default class extends Controller {
  connect() {
  }
  click(e) {
    e.stopPropagation()
  }
}
