import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="email-tracking"
export default class extends Controller {
  static targets = ["email"];
  static values = { activityId: Number };
  connect() {
    console.log("Email tracking controller connected");
  }

  trackEmailInput() {
    // 捕捉到電子郵件欄位的輸入事件
    console.log("Email input changed:", this.emailTarget.value);
    let logType = "email_field_changed";
    let activityId = this.activityIdValue;
    // 發送日誌到後端
    fetch("/logs/create", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector("[name='csrf-token']").content,
      },
      body: JSON.stringify({
        log_type: "email_field_changed",
        activity_id: activityId,
      }),
    }).then((response) => {
      if (response.ok) {
        console.log(logType);
      } else {
        console.log("Failed to record log");
      }
    });
  }
}
