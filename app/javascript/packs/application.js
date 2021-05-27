// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

const importAll = (r) => r.keys().map(r)
importAll(require.context('images', false, /\.(png|jpe?g|svg)$/i));
//importAll(require.context('@fortawesome/fontawesome-free/webfonts', false, /\.(eot|svg|ttf|woff2?)$/i));

import "core-js/stable";
import "regenerator-runtime/runtime";
import "@stimulus/polyfills";

import "@coreui/coreui/dist/js/coreui.bundle";

import "stylesheets/application"

require("@rails/ujs").start()
require("turbolinks").start()
//require("@rails/activestorage").start()
require("channels")

import "controllers";
