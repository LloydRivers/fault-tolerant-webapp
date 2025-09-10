document.addEventListener("DOMContentLoaded", function () {
  const serviceBoxes = document.querySelectorAll(".service-box");

  serviceBoxes.forEach((box, index) => {
    box.style.animationDelay = `${index * 0.1}s`;
    box.style.animation = "fadeInUp 0.6s ease-out forwards";
  });

  const style = document.createElement("style");
  style.textContent = `
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
    `;
  document.head.appendChild(style);
});
