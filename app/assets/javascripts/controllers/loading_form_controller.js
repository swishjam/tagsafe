import { Controller } from "stimulus"

export default class extends Controller {
  connect() {
    this.element.addEventListener('submit', () => this._displayLoading())
  }

  _displayLoading() {
    const btn = this.element.querySelector('input[type="submit"], button[type="submit"]');
    btn.classList.add('opacity-50', 'cursor-not-allowed');
    btn.innerHTML = '<svg class="animate-spin -ml-1 mr-3 h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24"><circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle><path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v8H4z"></path></svg>';
  }
}
