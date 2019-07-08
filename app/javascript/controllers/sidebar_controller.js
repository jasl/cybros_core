import { Controller } from "stimulus";
import $ from 'jquery';
import { toggleClasses } from './utils';

const SIDEBAR_MINIMIZER = '.sidebar-minimizer';
const NAV_DROPDOWN_TOGGLE = '.nav-dropdown-toggle';
const SIDEBAR_TOGGLER = '.sidebar-toggler';

const SIDEBAR_MINIMIZED = 'sidebar-minimized';
const OPEN = 'open';
const ShowClassNames = [
  'sidebar-show',
  'sidebar-sm-show',
  'sidebar-md-show',
  'sidebar-lg-show',
  'sidebar-xl-show'
]

export default class extends Controller {
  connect() {
    this._addMediaQuery();
    $(SIDEBAR_MINIMIZER).on('click', this.handleClick);
    $(document).on('click', SIDEBAR_TOGGLER, this.handleSideBarToggler);
    $(document).on('click', NAV_DROPDOWN_TOGGLE, this.handleDropDownToggle);
  }
  disconnect() {
    $(SIDEBAR_MINIMIZER).off('click', this.handleClick);
    $(document).off('click', SIDEBAR_TOGGLER, this.handleSideBarToggler);
    $(document).off('click', NAV_DROPDOWN_TOGGLE, this.handleDropDownToggle);
    this._removeClickOut();
  }
  // 绑定sidebar事件
  handleClick = (event) => {
    event.preventDefault();
    event.stopPropagation();
    $('body').toggleClass(SIDEBAR_MINIMIZED);
  }
  // mobile模式暂开菜单
  handleSideBarToggler = (event) => {
    event.preventDefault();
    event.stopPropagation();
    const toggle = event.currentTarget.dataset ? event.currentTarget.dataset.toggle : $(event.currentTarget).data('toggle');
    toggleClasses(toggle, ShowClassNames);
    this._toggleClickOut();
  }
  // 支持二级下拉菜单
  handleDropDownToggle = (event) => {
    const dropdown = event.target;
    event.preventDefault();
    event.stopPropagation();
    $(dropdown).parent().toggleClass(OPEN);
  }

  _addMediaQuery() {
    const sm = $(document.body).css('--breakpoint-sm');
    if (!sm) {
      return;
    }
    const smVal = parseInt(sm, 10) - 1;
    const mediaQueryList = window.matchMedia(`(max-width: ${smVal}px)`);
    this._breakpointTest(mediaQueryList);
    mediaQueryList.addListener(this._breakpointTest);
  }
  _breakpointTest = (e) => {
    this.mobile = Boolean(e.matches);
    this._toggleClickOut();
  }
  _toggleClickOut() {
    if (this.mobile && document.body.classList.contains('sidebar-show')) {
      document.body.classList.remove('aside-menu-show');
      this._addClickOut();
    } else {
      this._removeClickOut();
    }
  }
  _addClickOut = () => {
    document.addEventListener('click', this._clickOutListener, true);
  }
  _removeClickOut = () => {
    document.removeEventListener('click', this._clickOutListener, true);
  }
  _clickOutListener = (event) => {
    if (!this.element.contains(event.target)) { // or use: event.target.closest(SIDEBAR) === null
      event.preventDefault();
      event.stopPropagation();
      this._removeClickOut();
      document.body.classList.remove('sidebar-show');
    }
  }
}
