import { Controller } from "stimulus";
import $ from 'jquery';

const SIDEBAR_MINIMIZER = '.sidebar-minimizer';
const SIDEBAR_MINIMIZED = 'sidebar-minimized';

export default class extends Controller {
  connect() {
    // 绑定sidebar事件
    $(SIDEBAR_MINIMIZER).on('click', this.handleClick);
  }
  disconnect() {
    $(SIDEBAR_MINIMIZER).off('click', this.handleClick);
  }
  handleClick = (event) => {
    event.preventDefault()
    event.stopPropagation()
    $('body').toggleClass(SIDEBAR_MINIMIZED)
  }
}
