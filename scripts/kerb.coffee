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
#   hubot what's on kerb tomorrow
#   hubot what's on kerb on wednesday
#   hubot what's on kerb next tuesday
#   hubot kerb trader <trader name>

jsdom = require "jsdom"

days_of_week = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
kerb_alternatives = ["Pret", "Wasabi", "Benito's Hat", "Burrito Café", "Kiosk"]

getDate = (next_week, day_of_week_str) ->
  today = new Date()
  day_of_week = today.getDay()

  days_to_add = 0
  if next_week then days_to_add = 7

  day_index = days_of_week.indexOf(day_of_week_str)
  days_until_date = (day_index - day_of_week) + days_to_add
  new_date = new Date()
  new_date.setDate(today.getDate() + days_until_date)
  return new_date

formatDate = (d) ->
  day = d.getDate()
  if day < 10 then day = '0' + day
  month  = (d.getMonth() + 1)
  if month < 10 then month = '0' + month
  formatted_date = d.getFullYear() + "-" + month + "-" + day
  return formatted_date

tradersOnDate = (msg, formatted_date) ->
  url = "http://www.kerbfood.com/kings-cross/"
  jsdom.env url, [ "http://code.jquery.com/jquery-1.5.min.js" ], (errors, window) ->
    traders = window.$("#date-"+formatted_date+" ul li div.rota_content")
    message_str = "Traders for " + formatted_date + "\n"
    traders.each (index, element) =>
      trader_link = window.$(element).children("h4").children("a").attr('href').split("/")[2];
      trader_name = window.$(element).children("h4").text()
      trader_desc = window.$(element).children("p").text() + " ("+trader_link+")"

      message_str += trader_name + "\n"
      message_str += "  " + trader_desc + "\n"

    if message_str is "Traders for " + formatted_date + "\n"
      kerb_alternative = kerb_alternatives[Math.floor(Math.random()*kerb_alternatives.length)]
      message_str = 'No traders found for ' + formatted_date + ', how about heading to ' + kerb_alternative + '?'

    msg.send message_str

displayTradersForDay = (msg, next_week, day_of_week) ->
  date = getDate(next_week, day_of_week)
  tradersOnDate(msg, formatDate(date))

module.exports = (robot) ->
  robot.respond /kerb trader (.*)/i, (msg) ->
    url = "http://www.kerbfood.com/traders/"+msg.match[1]+'/'
    jsdom.env url, [ "http://code.jquery.com/jquery-1.5.min.js" ], (errors, window) ->
      trader_panel = window.$(".panel")[1]
      msg.send window.$(trader_panel).children("p").text()

  robot.respond /what(\')?s on kerb (on|next)?(.*)/i, (msg) ->
    day_of_week = msg.match[3].replace(/[ \?]/g,'')
    if day_of_week is 'tomorrow'
      today = new Date()
      day_of_week = days_of_week[today.getDay() + 1]
      displayTradersForDay(msg, false, day_of_week)
    else
      next_week = msg.match[2] == 'next'
      day_of_week = day_of_week.charAt(0).toUpperCase() + day_of_week.slice(1)
      displayTradersForDay(msg, next_week, day_of_week)

  robot.respond /what(\')?s on kerb\??$/i, (msg) ->
    formatted_date = formatDate(new Date())
    tradersOnDate(msg, formatted_date)
