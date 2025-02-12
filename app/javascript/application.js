// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
// import "controllers"
import "channels"
import "bootstrap"
import "./controllers";
import "./message_highlight";
import "./sidebar_message";
import "./sidebar_dialogue";
import "./clearing_response";
import "./scroll";
import { Modal } from "bootstrap";
window.bootstrap = { Modal };