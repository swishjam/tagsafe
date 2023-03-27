import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ['textInput', 'copyButton'];

  copyText() {
    this.textInputTarget.select();
    navigator.clipboard.writeText(this.textInputTarget.value);
    this.copyButtonTarget.classList.add('bg-green-200', 'hover:bg-green-200');
    const ogCopyBtnHTML = this.copyButtonTarget.innerHTML;
    this.copyButtonTarget.innerHTML = 'Copied!';
    setTimeout(() => {
      this.copyButtonTarget.classList.remove('bg-green-200', 'hover:bg-green-200');
      this.copyButtonTarget.innerHTML = ogCopyBtnHTML;
    }, 3_000);
  }
}
