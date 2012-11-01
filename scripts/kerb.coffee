# Description:
#   Make hubot list what tasty treats are available at Kerb Kings Cross (eat.st)
#
# Dependencies:
#
# Configuration:
#   None
#
# Commands:
#   hubot what's on kerb

jsdom = require "jsdom"

module.exports = (robot) ->
  robot.respond /what\'s on kerb/i, (msg) ->
    url = "http://www.kerbfood.com/kings-cross/"

    jsdom.env url, [ "http://code.jquery.com/jquery-1.5.min.js" ], (errors, window) ->
      d = new Date();
      day = d.getDate()
      if day < 10 then day = '0' + day
      month  = (d.getMonth() + 1)
      if month < 10 then month = '0' + month
      formatted_date = d.getFullYear() + "-" + month + "-" + day

      traders = window.$("#date-"+formatted_date+" ul li div.rota_content")
      message_str = "\n"
      traders.each (index, element) =>
        trader_name = window.$(element).children("h4").text()
        trader_desc = window.$(element).children("p").text()

        message_str += trader_name + "\n"
        message_str += "  " + trader_desc + "\n"

      msg.send message_str