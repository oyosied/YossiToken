const token = artifacts.require("YossiToken");

module.exports = function (deployer) {
  deployer.deploy(token);
};
