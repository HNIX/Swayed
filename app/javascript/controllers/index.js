// Load all the controllers within this directory and all subdirectories.
// Controller files must be named *_controller.js.

import { application } from "./application"

// Register each controller with Stimulus
import controllers from "./**/*_controller.js"
controllers.forEach((controller) => {
  application.register(controller.name, controller.module.default)
})

import { Dropdown, Tabs, Popover, Toggle, Slideover } from "tailwindcss-stimulus-components"

application.register('dropdown', Dropdown)
application.register('tabs', Tabs)
application.register('popover', Popover)
application.register('toggle', Toggle)
application.register('slideover', Slideover)

import Sortable from 'stimulus-sortable'
application.register('sortable', Sortable)

import Flatpickr from 'stimulus-flatpickr'
application.register('flatpickr', Flatpickr)

import Autosave from 'stimulus-rails-autosave'
application.register('autosave', Autosave)

//import Carousel from 'stimulus-carousel'
//application.register('carousel', Carousel)
import setupUltimateTurboModal from "ultimate_turbo_modal";
setupUltimateTurboModal(application);

import Rails from '@rails/ujs';
Rails.start();







