/* eslint no-console:0 */

// Rails functionality
import Rails from "@rails/ujs"
import "@hotwired/turbo-rails"

// Make accessible for Electron and Mobile adapters
window.Rails = Rails

// Swiper
import "swiper/css/bundle"

require("@rails/activestorage").start()
import "@rails/actiontext"

// ActionCable Channels
import "./channels"

// Stimulus controllers
import "./controllers"

// Jumpstart Pro & other Functionality
import "./src/**/*"
require("local-time").start()

//Chartkick
import "chartkick/chart.js"

// Start Rails UJS
Rails.start()
