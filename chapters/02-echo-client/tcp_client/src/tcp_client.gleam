import gleam/string
import logging
import gleam/erlang/atom.{type Atom}
import glisten/socket.{type ListenSocket, type SocketReason}

@external(erlang, "tcp_ffi", "connect")
pub fn connect(address: String, port: Int, options: List(Atom), timeout: Int) -> Result(ListenSocket, SocketReason)

pub fn main() {
  logging.configure()
  logging.log(logging.Info, "main")

  let assert Ok(ls) = connect("tcpbin.com", 4242, [atom.create("binary")], 1000)
  logging.log(logging.Info, string.inspect(ls))
}