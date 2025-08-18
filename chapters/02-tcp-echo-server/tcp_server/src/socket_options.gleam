/// Mode for the socket.  Currently `list` is not supported
pub type SocketMode {
  Binary
}

/// Mapping to the `{active, _}` option
pub type ActiveState {
  Once
  Passive
  Count(Int)
  Active
}

pub type IpAddress {
  IpV4(Int, Int, Int, Int)
  IpV6(Int, Int, Int, Int, Int, Int, Int, Int)
}

pub type Interface {
  Address(IpAddress)
  Any
  Loopback
}

pub type TlsCerts {
  CertKeyFiles(certfile: String, keyfile: String)
}

/// Options for the TCP socket
pub type TcpOption {
  Debug(Bool)
  Backlog(Int)
  Nodelay(Bool)
  Linger(#(Bool, Int))
  SendTimeout(Int)
  SendTimeoutClose(Bool)
  Reuseaddr(Bool)
  ActiveMode(ActiveState)
  Mode(SocketMode)
  // TODO:  Probably should adjust the type here to only allow this for TLS
  CertKeyConfig(TlsCerts)
  AlpnPreferredProtocols(List(String))
  Ipv6
  Buffer(Int)
  Ip(Interface)
}
