import RedirectFormController from './redirect_form_controller'
import * as Bootstrap from 'bootstrap'

export default class ModalController extends RedirectFormController {
  connect() {
    this.modal = new Bootstrap.Modal(this.element)
  }

  open() {
    if (!this.modal.isOpened) {
      this.modal.show()
    }
  }

  close(event) {
    if (event.detail.success) {
      this.modal.hide()
    }
  }
}
