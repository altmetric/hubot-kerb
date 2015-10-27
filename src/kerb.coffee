# Description:
#   A Hubot script to check what's on KERB
#
# Dependencies:
#   "cheerio": "^0.19.0"
#   "chrono-node": "^1.0.8"
#
# Configuration:
#   KERB_URL - URL of the KERB location to scrape. Default: http://www.kerbfood.com/kings-cross/
#
# Commands:
#   hubot what's on kerb
#   hubot what's on kerb tomorrow
#   hubot what's on kerb on wednesday
#   hubot what's on kerb next tuesday
#
# Author:
#   fuzzmonkey
#   richardkoks
#   mudge

cheerio = require 'cheerio'
chrono = require 'chrono-node'

kerbUrl = process.env.KERB_URL or 'http://www.kerbfood.com/kings-cross/'

module.exports = (robot) ->
  robot.respond /what'?s on kerb\??$/i, (res) ->
    tradersForDate(new Date(), res)

  robot.respond /what'?s on kerb (.+)\??/i, (res) ->
    date = chrono.parseDate(res.match[1])
    tradersForDate(date, res)

  tradersForDate = (date, res) ->
    dateId = "#date-#{ date.toISOString().slice(0, 10) }"

    robot.http(kerbUrl).get() (err, _resp, body) ->
      if err
        res.send "Sorry, I'm struggling to check #{ kerbUrl } right now!"
      else
        $ = cheerio.load(body)

        traders = $("#{ dateId } ul li div.rota_content")
          .map ->
            traderName = $('h4', this).text()
            traderDescription = $('p', this).text()
            traderLink = $('h4 a', this).attr('href')

            "#{ traderName } (http://www.kerbfood.com#{ traderLink })\n  #{ traderDescription }"
          .get()

        if traders.length
          res.send traders.join("\n")
        else
          res.send 'Sorry, no traders found!'

