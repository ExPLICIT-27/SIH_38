// Animation state
const pathEl = document.getElementById("flowPath");
const markerEl = document.getElementById("marker");
const playPauseBtn = document.getElementById("playPause");
const resetBtn = document.getElementById("reset");
const speedInput = document.getElementById("speed");
const speedVal = document.getElementById("speedVal");

let totalLen = 0;
let progress = 0; // in path length units
let playing = false;
let speed = 1; // 1x
let lastTs = null;

// Map of milestones along the path to highlight blocks (approximate)
const milestones = [
  { ratio: 0.02, id: "block-flutter" },
  { ratio: 0.18, id: "block-nest" },
  { ratio: 0.33, id: "block-ipfs" },
  { ratio: 0.48, id: "block-pg" },
  { ratio: 0.6, id: "block-verify" },
  { ratio: 0.72, id: "block-anchor" },
  { ratio: 0.86, id: "block-sol" },
  { ratio: 0.96, id: "block-market" },
];

function setActiveBlock(id) {
  [
    "block-flutter",
    "block-nest",
    "block-ipfs",
    "block-pg",
    "block-verify",
    "block-anchor",
    "block-sol",
    "block-market",
  ].forEach((b) => {
    const el = document.getElementById(b);
    if (!el) return;
    if (b === id) el.classList.add("active");
    else el.classList.remove("active");
  });
}

function updateMarker() {
  const pt = pathEl.getPointAtLength(progress);
  markerEl.setAttribute("cx", String(pt.x));
  markerEl.setAttribute("cy", String(pt.y));
  const ratio = totalLen > 0 ? progress / totalLen : 0;
  let current = milestones[0].id;
  for (let i = 0; i < milestones.length; i++) {
    if (ratio >= milestones[i].ratio) current = milestones[i].id;
  }
  setActiveBlock(current);
}

function rafStep(ts) {
  if (!playing) {
    lastTs = null;
    return;
  }
  if (lastTs == null) lastTs = ts;
  const dt = (ts - lastTs) / 1000; // seconds
  lastTs = ts;

  const pixelsPerSecond = 140; // base speed along the path
  progress += dt * speed * pixelsPerSecond;
  if (progress >= totalLen) {
    progress = totalLen;
    playing = false;
    updatePlayPauseLabel();
  }
  updateMarker();
  if (playing) requestAnimationFrame(rafStep);
}

function updatePlayPauseLabel() {
  playPauseBtn.textContent = playing ? "Pause" : progress >= totalLen ? "Replay" : "Play";
}

function play() {
  if (progress >= totalLen) progress = 0; // replay from start
  if (!playing) {
    playing = true;
    updatePlayPauseLabel();
    requestAnimationFrame(rafStep);
  }
}

function pause() {
  playing = false;
  updatePlayPauseLabel();
}

function reset() {
  playing = false;
  progress = 0;
  updateMarker();
  updatePlayPauseLabel();
}

// Wire up controls
playPauseBtn.addEventListener("click", () => {
  if (playing) pause();
  else play();
});

resetBtn.addEventListener("click", () => reset());

speedInput.addEventListener("input", () => {
  speed = parseFloat(speedInput.value || "1") || 1;
  speedVal.textContent = `${speed.toFixed(1)}x`;
});

// Initialize once DOM and resources are ready
function init() {
  try {
    totalLen = pathEl.getTotalLength();
  } catch (_) {
    totalLen = 0;
  }
  speed = parseFloat(speedInput.value || "1") || 1;
  speedVal.textContent = `${speed.toFixed(1)}x`;
  updateMarker();
}

if (document.readyState === "complete" || document.readyState === "interactive") {
  setTimeout(init, 0);
} else {
  document.addEventListener("DOMContentLoaded", init);
}
