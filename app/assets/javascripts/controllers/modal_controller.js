import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ['backdrop'];

  connect() {
    this.showModal = this.showModal.bind(this);
    this.hideModal = this.hideModal.bind(this);
  }

  showModal() {
    this.backdropTarget.classList.remove('hidden');
    setTimeout(() => {
      this.backdropTarget.classList.replace('opacity-0', 'opacity-100');
    }, 50);
  }

  hideModal() {
    this.backdropTarget.classList.replace('opacity-100', 'opacity-0');
    setTimeout(() => this.backdropTarget.classList.add('hidden'), 200);
  }
}
