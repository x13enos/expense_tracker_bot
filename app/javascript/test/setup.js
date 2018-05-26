require('jsdom-global')()

var chai = require("chai");
var chaiAsPromised = require("chai-as-promised");
chai.use(chaiAsPromised);

global.sinon = require('sinon')
global.expect = chai.expect
