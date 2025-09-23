// Stars background
const stars = document.getElementById("stars");
const starCount = 120;
const starElems = [];
function initStars() {
  const frag = document.createDocumentFragment();
  for (let i = 0; i < starCount; i++) {
    const s = document.createElement("div");
    const size = Math.random() * 2 + 1;
    const x = Math.random() * 100;
    const y = Math.random() * 100;
    const delay = Math.random() * 6;
    s.style.cssText =
      `position:absolute;width:${size}px;height:${size}px;border-radius:50%;` +
      `background: rgba(255,255,255,${0.6 + Math.random() * 0.4});` +
      `left:${x}%;top:${y}%;box-shadow:0 0 ${6 + Math.random() * 10}px rgba(255,255,255,0.7);` +
      `animation: twinkle 6s ${delay}s infinite ease-in-out;`;
    frag.appendChild(s);
    starElems.push(s);
  }
  stars.appendChild(frag);
}

// Theme toggle
const themeToggle = document.getElementById("themeToggle");
const prefersLight = window.matchMedia("(prefers-color-scheme: light)").matches;
function setTheme(theme) {
  if (theme === "light") document.documentElement.classList.add("light");
  else document.documentElement.classList.remove("light");
  localStorage.setItem("theme", theme);
  themeToggle.textContent = theme === "light" ? "☀️" : "🌙";
}
function initTheme() {
  const saved = localStorage.getItem("theme");
  setTheme(saved || (prefersLight ? "light" : "dark"));
}
themeToggle.addEventListener("click", () => {
  const isLight = document.documentElement.classList.contains("light");
  setTheme(isLight ? "dark" : "light");
});

// Reveal on scroll
const revealEls = [];
function initReveal() {
  document.querySelectorAll(".reveal").forEach((el) => revealEls.push(el));
  const io = new IntersectionObserver(
    (entries) => {
      entries.forEach((e) => {
        if (e.isIntersecting) {
          e.target.classList.add("visible");
          io.unobserve(e.target);
        }
      });
    },
    { threshold: 0.12 }
  );
  revealEls.forEach((el) => io.observe(el));
}

// Smooth scroll for nav
document.querySelectorAll('a[href^="#"]').forEach((a) => {
  a.addEventListener("click", (e) => {
    const id = a.getAttribute("href");
    const target = document.querySelector(id);
    if (target) {
      e.preventDefault();
      target.scrollIntoView({ behavior: "smooth", block: "start" });
    }
  });
});

// Simple highlight on diagram hover
function initDiagram() {
  const img = document.querySelector(".diagram img");
  if (!img) return;
  img.addEventListener("mousemove", (e) => {
    const rect = img.getBoundingClientRect();
    const x = (e.clientX - rect.left) / rect.width;
    const y = (e.clientY - rect.top) / rect.height;
    img.style.filter = `drop-shadow(${(x - 0.5) * 14}px ${
      (y - 0.5) * 14
    }px 22px rgba(92,225,230,0.25))`;
  });
  img.addEventListener("mouseleave", () => {
    img.style.filter = "drop-shadow(0 20px 80px rgba(0,0,0,0.4))";
  });
}

// Keyframes
const style = document.createElement("style");
style.textContent = `@keyframes twinkle { 0%,100%{ opacity: 0.4 } 50%{ opacity: 1 } }`;
document.head.appendChild(style);

// Init
initStars();
initTheme();
initReveal();
initDiagram();
