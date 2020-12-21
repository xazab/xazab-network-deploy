const RpcClient = require('@xazab/xazabd-rpc/promise');
const getNetworkConfig = require('./getNetworkConfig');

const { inventory, variables } = getNetworkConfig();

/**
 * @param {string} hostName
 * @return {RpcClient}
 */
function createRpcClientFromConfig(hostName) {
  const options = {
    protocol: 'http',
    user: variables.xazabd_rpc_user,
    pass: variables.xazabd_rpc_password,
    // eslint-disable-next-line no-underscore-dangle
    host: inventory._meta.hostvars[hostName].public_ip,
    port: variables.xazabd_rpc_port,
  };

  return new RpcClient(options);
}

module.exports = createRpcClientFromConfig;
