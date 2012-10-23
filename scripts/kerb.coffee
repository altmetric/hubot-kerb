# Description:
#   Make hubot list what tasty treats are available at Kerb Kings Cross (eat.st)
#
# Dependencies:
#
# Configuration:
#   None
#
# Commands:
#   hubot what's on eat.st

jsdom = require "jsdom"

module.exports = (robot) ->
  robot.respond /what\'s on kerb/i, (msg) ->
    url = "http://www.kerbfood.com/kings-cross/"

    jsdom.env url, [ "http://code.jquery.com/jquery-1.5.min.js" ], (errors, window) ->
      d = new Date();
      formatted_date = d.getFullYear() + "-" + (d.getMonth() + 1) + "-" + d.getDate()
      traders = window.$("#date-"+formatted_date+" ul li div.rota_content")
      message_str = "\n"
      traders.each (index, element) =>
        trader_name = window.$(element).children("h4").text()
        trader_desc = window.$(element).children("p").text()

        message_str += trader_name + "\n"
        message_str += "  " + trader_desc + "\n"

      msg.send message_str
