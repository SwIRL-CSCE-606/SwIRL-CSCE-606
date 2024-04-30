import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="countdown"
export default class extends Controller {
  static targets = ["countdown"];

  connect() {
    console.log("Connected");

    this.eventID = this.element.dataset.eventId;

    this.secondsUntilEnd = this.countdownTarget.dataset.secondsUntilEndValue;

    const now = new Date().getTime();
    this.endTime = new Date(now + this.secondsUntilEnd * 1000);

    this.countdown = setInterval(this.countdown.bind(this), 1000);
  }

  countdown() {
    const now = new Date();
    const secondsRemaining = (this.endTime - now) / 1000;

    if (secondsRemaining <= 0) {
      clearInterval(this.countdown);
      this.countdownTarget.innerHTML = "Send Reminder Email";

      // this.inviteAttendees(this.eventID);
      return;
    }

    const secondsPerDay = 86400;
    const secondsPerHour = 3600;
    const secondsPerMinute = 60;

    const days = Math.floor(secondsRemaining / secondsPerDay);
    const hours = Math.floor((secondsRemaining % secondsPerDay) / secondsPerHour);
    const minutes = Math.floor((secondsRemaining % secondsPerHour) / secondsPerMinute);
    const seconds = Math.floor(secondsRemaining % secondsPerMinute);
    console.log(days, hours, minutes);

    this.countdownTarget.innerHTML = `Time for Reminder: ${days} days, ${hours} hours, ${minutes} minutes, ${seconds} seconds`;
  }

  inviteAttendees(eventID) {
    // Make AJAX request to call invite_attendees function
    fetch(`/invite_attendees/${eventID}`, {
      method: 'GET',
    })
      .then(response => {
        if (!response.ok) {
          throw new Error('Failed to invite attendees');
        }
        console.log('Invite attendees successfully');
      })
      .catch(error => {
        console.error('Error inviting attendees:', error);
      });
  }
}
