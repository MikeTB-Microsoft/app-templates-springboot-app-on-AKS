resource symbolicname 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-11-01' = {
  name: 'vnetPeering/'
  properties: {
    allowForwardedTraffic: true
    allowGatewayTransit: true
    allowVirtualNetworkAccess: true
    doNotVerifyRemoteGateways: true
    enableOnlyIPv6Peering: true
    localAddressSpace: {
      addressPrefixes: [
        '10.50.0.0/16'
      ]
    }
    localSubnetNames: [
      'ilb, AzureBastionSubnet, AzureFirewallSubnet, mgmt'
    ]
    localVirtualNetworkAddressSpace: {
      addressPrefixes: [
        '10.50.0.0/16'
      ]
    }
    peerCompleteVnets: true
    peeringState: 'Connected'
    peeringSyncLevel: 'FullyInSync'
    remoteAddressSpace: {
      addressPrefixes: [
        '10.51.0.0/16'
      ]
    }
    remoteBgpCommunities: {
      virtualNetworkCommunity: 'hubvnetName, spokevnetName'
    }
    remoteSubnetNames: [
      'aksSubnet, acrSubnet, kvSubnet, pgfsSubnet'
    ]
    remoteVirtualNetwork: {
      id: 'c3caea05-d40f-4cd5-a694-68a5bef3904d'
    }
    remoteVirtualNetworkAddressSpace: {
      addressPrefixes: [
        '10.51.0.0/16'
      ]
    }
    useRemoteGateways: false
  }
}
