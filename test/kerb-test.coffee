Helper = require('hubot-test-helper')
nock = require('nock')
fs = require('fs')
path = require('path')
expect = require('chai').expect

helper = new Helper('../src/kerb.coffee')

describe 'kerb', ->
  beforeEach ->
    @room = helper.createRoom(httpd: false)

  afterEach ->
    nock.cleanAll()

  context 'when the user supplies an invalid date', ->
    beforeEach (done) ->
      nock('http://www.kerbfood.com')
        .get('/kings-cross/')
        .reply(200, '')

      @room.user.say 'alice', 'hubot whats on kerb blah blah'
      setTimeout done, 100

    it 'responds with an error message', ->
      expect(@room.messages).to.eql [
        ['alice', 'hubot whats on kerb blah blah'],
        ['hubot', 'Sorry, I didn\'t understand that date. Try something like "what\'s on kerb tomorrow?" or "what\'s on kerb on Thursday?"']
      ]

  context 'when the KERB site is down', ->
    beforeEach (done) ->
      nock('http://www.kerbfood.com')
        .get('/kings-cross/')
        .replyWithError('Jings me boab!')

      @room.user.say 'alice', 'hubot whats on kerb?'
      setTimeout done, 100

    it 'responds with an error message', ->
      expect(@room.messages).to.eql [
        ['alice', 'hubot whats on kerb?'],
        ['hubot', 'Sorry, I\'m struggling to check http://www.kerbfood.com/kings-cross/ right now!']
      ]

  context 'when there are no traders for the given date', ->
    beforeEach (done) ->
      nock('http://www.kerbfood.com')
        .get('/kings-cross/')
        .reply(200, '')

      @room.user.say 'alice', 'hubot whats on kerb on 2015-01-01?'
      setTimeout done, 100

    it 'responds with an error message', ->
      expect(@room.messages).to.eql [
        ['alice', 'hubot whats on kerb on 2015-01-01?'],
        ['hubot', 'Sorry, no traders found!']
      ]

  context 'there are traders for the given date', ->
    beforeEach (done) ->
      nock('http://www.kerbfood.com')
        .get('/kings-cross/')
        .reply(200, fs.readFileSync(path.join(__dirname, '/fixtures/kings-cross.html')))

      @room.user.say 'alice', 'hubot what’s on kerb on 2015-10-28?'
      setTimeout done, 100

    it 'responds with the traders for that date', ->
      expect(@room.messages).to.eql [
        ['alice', 'hubot what’s on kerb on 2015-10-28?'],
        ['hubot', 'Luardos (http://www.kerbfood.com/traders/luardos/)\n  The original burrito boy. Deep in the game, ain\'t coming out any time soon.\nStakehaus (http://www.kerbfood.com/traders/stakehaus/)\n  Home to great steaks\nVinn Goute - Seychelles Kitchen (http://www.kerbfood.com/traders/vinn-goute/)\n  Never had Seychelles cooking before? You\'re in for a treat.\nWell Kneaded (http://www.kerbfood.com/traders/well-kneaded/)\n  Pizza wagon on a mission']
      ]
