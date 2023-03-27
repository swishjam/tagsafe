import { Controller } from "stimulus"

export default class extends Controller {
  connect() {
    this.element.addEventListener('mouseover', () => {
      this.tooltip || this._initializePopperTooltip();
      this.tooltip.update();
      this.tooltipEl.classList.remove('hidden')
    });
    this.element.addEventListener('mouseout', () => this.tooltipEl.classList.add('hidden'));
  }

  disconnect() {
    if (this.tooltipEl) this.tooltipEl.remove();
  }

  _initializePopperTooltip() {
    this.tooltipEl = this._createTooltipEl();
    this.tooltip = Popper.createPopper(this.element, this.tooltipEl, {
      placement: 'top',
      modifiers: [
        {
          name: 'offset',
          options: {
            offset: [0, 8],
          },
        },
      ],
    });
  }

  _createTooltipEl() {
    const el = document.createElement('div');
    el.classList.add(
      'tagsafe-tooltip', 'hidden', 'cursor-default', 'max-w-xs', 'border', 'text-sm', 'bg-white', 'text-gray-700', 'px-2',
      'py-2', 'rounded-lg', 'shadow-lg', 'text-center'
    );
    el.innerText = this.element.getAttribute('title');
    document.body.appendChild(el);
    return el;
  }
}
