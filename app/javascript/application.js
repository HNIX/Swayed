/* eslint no-console:0 */

import "@hotwired/turbo-rails"
require("@rails/activestorage").start()
require("local-time").start()

import "./channels"
import "./controllers"
import "./src/**/*"
require("local-time").start()

//Chartkick
import "chartkick/chart.js"


addEventListener("turbo:before-frame-render", (event) => {
    event.detail.render = (currentElement, newElement) => {
        Idiomorph.morph(currentElement, newElement, {
        morphstyle: 'innerHTML'
        })
    }
})