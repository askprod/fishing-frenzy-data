class Loader {
  constructor(container) {
    this.container = container;
    this.overlay = null;
    this.loader = null;
  }

  show() {
    if (!this.overlay) {
      this.createLoader();
    }

    requestAnimationFrame(() => {
      this.overlay.classList.remove("opacity-0", "pointer-events-none");
      this.overlay.classList.add("opacity-100");
    });
  }

  hide(callback) {
    if (!this.overlay) return;
    
    this.overlay.classList.remove("opacity-100");
    this.overlay.classList.add("opacity-0");

    setTimeout(() => {
      this.overlay.classList.add("pointer-events-none");

      if (callback) {
        callback();
      }
    }, 500);
  }

  createLoader() {
    this.overlay = document.createElement("div");
    this.overlay.classList.add(
      "absolute",
      "inset-0",
      "backdrop-blur-xs",
      "bg-white/10",
      "flex",
      "items-center",
      "justify-center",
      "opacity-0",
      "transition-opacity",
      "duration-500",
      "z-10",
      "pointer-events-none"
    );

    this.loader = document.createElement("img");
    this.loader.src = js_utils.loader; // Replace with your image path
    this.loader.alt = "Loading...";
    this.loader.classList.add(
      "w-8", "h-auto",
      "rounded-full",
      "animate-bounce",
    );

    this.overlay.appendChild(this.loader);
    this.container.classList.add("relative");
    this.container.appendChild(this.overlay);
  }
}

export default Loader;
