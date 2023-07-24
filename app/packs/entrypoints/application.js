import Rails from "@rails/ujs";
import "@hotwired/turbo-rails";
import { Application } from "@hotwired/stimulus";
import { definitionsFromContext } from "@hotwired/stimulus-webpack-helpers";
import "@popperjs/core"
import "bootstrap";
import '../scripts/sse.js';

// Setup for Stimulus.js
window.Stimulus = Application.start();
const context = require.context("../controllers", true, /\.js$/);
Stimulus.load(definitionsFromContext(context));

// Handle custom delete dialog.
Turbo.setConfirmMethod((message) => {
  let dialog = document.getElementById("turbo-confirm");
  dialog.querySelector("p").textContent = message;
  dialog.showModal();

  return new Promise((resolve, reject) => {
    dialog.addEventListener("close", () => {
      resolve(dialog.returnValue === "confirm")
    }, { once: true });
  });
});

Rails.start();