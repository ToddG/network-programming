import gleam/erlang/process
import gleam/string
import glisten/socket.{type ListenSocket, type SocketReason}
import logging
import socket_options.{type TcpOption, Binary, Mode, ActiveMode, Active}

@external(erlang, "tcp_ffi", "listen")
pub fn listen(
port: Int,
options: List(TcpOption),
) -> Result(ListenSocket, SocketReason)

pub fn main() {
  logging.configure()
  logging.log(logging.Info, "------------------------------------------------")
  logging.log(logging.Info, "tcp_server starting")
  logging.log(logging.Info, "------------------------------------------------")
  // goal:05:listen for a tcp connection (page 17)
  let assert Ok(socket) = listen(4000, [Mode(Binary), ActiveMode(Active)])
  logging.log(logging.Info, "socket: " <> string.inspect(socket))

  // sleep so we can ensure the logs print to the console
  process.sleep_forever()
}
