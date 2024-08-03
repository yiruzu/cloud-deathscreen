const audioElement = new Audio("/web/sound/heartbeat.mp3");
audioElement.loop = true;
audioElement.volume = 0.35; // Set audio volume

let currentTimer = 0;
let isDead = false;
let timerId;

window.addEventListener("message", handleMessage);

function handleMessage(event) {
  const { action, status, timer } = event.data;

  if (action === "show") {
    handleShow(status);
  } else if (action === "setTimer") {
    handleSetTimer(timer);
  }
}

function handleShow(status) {
  if (status) {
    startDeathSequence();
  } else {
    resetState();
  }
}

function handleSetTimer(timer) {
  clearTimeout(timerId);
  currentTimer = timer;
  timerId = setInterval(timerTick, 1000);
}

function timerTick() {
  if (!isDead) return;

  if (currentTimer <= 0) {
    onTimeExpired();
  } else {
    updateTimerDisplay(currentTimer);
    currentTimer--;
  }
}

function onTimeExpired() {
  $("#wrapper").fadeOut(250);
  triggerCallback("time_expired");
  clearTimeout(timerId);
  resetState();
}

function updateTimerDisplay(time) {
  const minutes = Math.floor(time / 60).toString().padStart(2, "0");
  const seconds = (time % 60).toString().padStart(2, "0");

  $("#timer span:eq(0)").text(minutes[0]);
  $("#timer span:eq(1)").text(minutes[1]);
  $("#timer span:eq(3)").text(seconds[0]);
  $("#timer span:eq(4)").text(seconds[1]);
}

function startDeathSequence() {
  isDead = true;
  currentTimer = 0;
  $("#wrapper").fadeIn(250);
  $("#call-emergency").removeClass("disabled");
  audioElement.play();
}

function resetState() {
  isDead = false;
  currentTimer = 0;
  $("#wrapper").fadeOut(250);
  audioElement.pause();
  audioElement.currentTime = 0;
}

$(function () {
  $("#face-death").click(() => triggerCallback("face_death"));
  $("#call-emergency").click(() => {
    triggerCallback("send_distress_signal");
    $("#call-emergency").addClass("disabled");
  });
  $("#wrapper").hide();
});

function triggerCallback(action) {
  $.post(`https://${GetParentResourceName()}/${action}`);
}
