import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ['menu'];

  connect() {
    this.toggle = this.toggle.bind(this);
    this._showDropdown = this._showDropdown.bind(this);
    this._hideDropdown = this._hideDropdown.bind(this);
    this._bodyClickListener = this._bodyClickListener.bind(this);
    this._elementIsOrIsChildOfEl = this._elementIsOrIsChildOfEl.bind(this);
  }

  toggle() {
    if(this.menuTarget.classList.contains('hidden')) {
      this._showDropdown();
    } else {
      this._hideDropdown();
    }
  }

  _showDropdown() {
    this.menuTarget.classList.remove('hidden');
    setTimeout(() => {
      document.body.addEventListener('click', this._bodyClickListener);
      this.menuTarget.classList.replace('opacity-0', 'opacity-100');
    }, 50);
  }

  _hideDropdown() {
    this.menuTarget.classList.replace('opacity-100', 'opacity-0');
    document.body.removeEventListener('click', this._bodyClickListener);
    setTimeout(() => this.menuTarget.classList.add('hidden'), 200);
  }

  _bodyClickListener(e) {
    if (!this._elementIsOrIsChildOfEl(e.target, this.menuTarget)) {
      this._hideDropdown();
    }
  }

  _elementIsOrIsChildOfEl(el, comparisonEl) {
    if (el === comparisonEl) {
      return true;
    } else if (el === document.body) {
      return false;
    } else if (el.parentElement) {
      return this._elementIsOrIsChildOfEl(el.parentElement, comparisonEl);
    }
  }
}
