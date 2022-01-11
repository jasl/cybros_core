import { Controller } from "stimulus";

const SIDEBAR_MINIMIZER = 'button.sidebar-minimizer';

export default class extends Controller {
  connect() {
    $(SIDEBAR_MINIMIZER).on('click', this.handleStoreSidebarStates);
    if(localStorage.getItem('coreui-sidebar-minimized') == 'true') {
      setTimeout(function(){
        $(SIDEBAR_MINIMIZER).click();
        setTimeout(function(){
          $('body').addClass('sidebar-minimized');
        }, 150);
      }, 20);
    }
  }

  handleStoreSidebarStates = (event) => {
    setTimeout(function(){
      if($('body.sidebar-minimized').length) {
        localStorage.setItem('coreui-sidebar-minimized', true);
      } else {
        localStorage.removeItem('coreui-sidebar-minimized');
      }
    }, 200);
  }

  disconnect() {
    if($('body.sidebar-minimized').length) {
      localStorage.setItem('coreui-sidebar-minimized', true);
    }
    $(SIDEBAR_MINIMIZER).off('click', this.handleStoreSidebarStates);
  }
}
