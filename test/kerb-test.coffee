chai = require 'chai'
sinon = require 'sinon'
chai.use require 'sinon-chai'

expect = chai.expect

describe 'kerb', ->
  beforeEach ->
    @robot =
      respond: sinon.spy()
      hear: sinon.spy()

    require('../src/kerb')(@robot)

  it 'registers a respond listener for today', ->
    expect(@robot.respond).to.have.been.calledWith(/what'?s on kerb\??$/i)

  it 'registers a respond listener for other dates', ->
    expect(@robot.respond).to.have.been.calledWith(/what'?s on kerb (.+)\??/i)
