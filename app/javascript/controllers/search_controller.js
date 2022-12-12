import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search"
export default class extends Controller {
  static targets=['navbar', 'searchnavbar']
  connect() {
    console.log(this.navbarTarget)
    console.log(this.searchnavbarTarget)
  }

  expand() {
    console.log("From expand")
    this.navbarTarget.classList.toggle('d-none')
    this.searchnavbarTarget.classList.toggle('d-none')
  }
}
