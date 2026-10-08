import Notification from "@stimulus-components/notification"
import { useTransition } from "stimulus-use"

// Connects to data-controller="notification"
export default class extends Notification {
  connect() {
    useTransition(this, {
      removeToClasses: false,
      preserveOriginalClass: false
    })
    if (this.hiddenValue === false) {
      this.show()
    }
  }


  pause() {
    if (this.timeout) {
      clearTimeout(this.timeout)
    }
  }

  resume() {
    if (this.timeout) {
      clearTimeout(this.timeout)
    }
    this.timeout = setTimeout(this.hide, this.delayValue)
  }

  disconnect() {
    if (this.timeout) {
      clearTimeout(this.timeout)
    }
    super.disconnect?.()
  }
}