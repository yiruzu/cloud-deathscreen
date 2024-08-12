const audioElement = new Audio("/web/sound/heartbeat.mp3");
audioElement.loop = true;
audioElement.volume = 0.35; // Set audio volume

let mainTimer = 0;
let faceDeathTimer = 0;
let isDead = false;
let faceDeathEnabled = false;
let mainTimerId;
let faceDeathTimerId;

window.addEventListener("message", handleMessage);

function handleMessage(event) {
  const { action, status, timers } = event.data;

  if (action === "show") {
    handleShow(status);
  } else if (action === "setTimers") {
    handleSetMainTimer(timers.mainTimer);
    handleSetFaceDeathTimer(timers.faceDeathTimer);
  }
}

function handleShow(status) {
  if (status) {
    startDeathSequence();
  } else {
    resetState();
  }
}

function handleSetMainTimer(timer) {
  clearInterval(mainTimerId);
  mainTimer = timer;
  mainTimerId = setInterval(mainTimerTick, 1000);
}

function handleSetFaceDeathTimer(timer) {
  clearInterval(faceDeathTimerId);
  faceDeathTimer = timer;
  faceDeathTimerId = setInterval(faceDeathTimerTick, 1000);
}

function mainTimerTick() {
  if (!isDead) return;

  if (mainTimer <= 0) {
    onMainTimerExpired();
  } else {
    updateMainTimerDisplay(mainTimer);
    mainTimer--;
  }
}

function faceDeathTimerTick() {
  if (!isDead) return;

  if (faceDeathTimer <= 0) {
    onFaceDeathTimerExpired();
  } else {
    faceDeathTimer--;
  }
}

function onMainTimerExpired() {
  $("#wrapper").fadeOut(250);
  triggerCallback("time_expired");
  clearInterval(mainTimerId);
  resetState();
}

function onFaceDeathTimerExpired() {
  faceDeathEnabled = true;
  $("#face-death").removeClass("disabled");
  clearInterval(faceDeathTimerId);
}

function updateMainTimerDisplay(time) {
  const minutes = Math.floor(time / 60) .toString() .padStart(2, "0");
  const seconds = (time % 60).toString().padStart(2, "0");

  $("#timer span:eq(0)").text(minutes[0]);
  $("#timer span:eq(1)").text(minutes[1]);
  $("#timer span:eq(3)").text(seconds[0]);
  $("#timer span:eq(4)").text(seconds[1]);
}

function startDeathSequence() {
  isDead = true;
  faceDeathEnabled = false;
  mainTimer = 0;
  faceDeathTimer = 0;
  $("#wrapper").fadeIn(250);
  $("#face-death").addClass("disabled");
  $("#call-emergency").removeClass("disabled");
  audioElement.play();
}

function resetState() {
  isDead = false;
  faceDeathEnabled = false;
  mainTimer = 0;
  faceDeathTimer = 0;
  clearInterval(mainTimerId);
  clearInterval(faceDeathTimerId);
  $("#wrapper").fadeOut(250);
  audioElement.pause();
  audioElement.currentTime = 0;
  $("#face-death").addClass("disabled");
}

$(function () {
  $("#face-death").click(() => {
    if (faceDeathEnabled) {
      triggerCallback("face_death");
    }
  });
  $("#call-emergency").click(() => {
    triggerCallback("send_distress_signal");
    $("#call-emergency").addClass("disabled");
  });
  $("#wrapper").hide();
});

function triggerCallback(action) {
  $.post(`https://${GetParentResourceName()}/${action}`);
}
