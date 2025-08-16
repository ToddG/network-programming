import gleam/bit_array
import gleam/bytes_tree.{type BytesTree}
import gleam/dynamic/decode
import gleam/erlang/atom.{type Atom}
import gleam/erlang/process
import gleam/string
import glisten/socket.{type Socket, type SocketReason}
import logging

@external(erlang, "tcp_ffi", "connect")
pub fn connect(
  address: String,
  port: Int,
  options: List(Atom),
  active: Bool,
  timeout: Int,
) -> Result(Socket, SocketReason)

@external(erlang, "tcp_ffi", "send")
pub fn send(socket: Socket, packet: BytesTree) -> Result(Nil, SocketReason)

@external(erlang, "gen_tcp", "recv")
pub fn recv(socket: Socket, length: Int, timeout: Int) -> Result(String, SocketReason)


pub fn main() {
  logging.configure()
  logging.log(logging.Info, "------------------------------------------------")
  logging.log(logging.Info, "active socket")
  logging.log(logging.Info, "------------------------------------------------")

  // goal:01:establish a tcp connection (socket mode = active) (page 13)
  let assert Ok(socket) =
    connect("tcpbin.com", 4242, [atom.create("binary")], True, 1000)
  logging.log(logging.Info, string.inspect(socket))

  // goal:02:send data on the tcp connection (page 14)
  let hw = "Hello, Wordl!\n"
  logging.log(logging.Info, "active socket send: " <> hw)
  let assert Ok(Nil) =
    send(socket, bytes_tree.from_bit_array(bit_array.from_string(hw)))

  // goal:03:receive data sent on the tcp connection...essentially flush the connection (page 14)
  let client_selector =
    process.select_other(
      process.new_selector(),
      decode.run(_, {
        use tcp <- decode.field(0, decode.dynamic)
        use port <- decode.field(1, decode.dynamic)
        use msg <- decode.field(2, decode.bit_array)
        decode.success(#(tcp, port, msg))
      }),
    )
  let msg = process.selector_receive(client_selector, 200)
  let assert Ok(Ok(#(tcp, port, message))) = msg
  let assert Ok(message) = bit_array.to_string(message)
  logging.log(
    logging.Info,
    "active socket received: tcp="
      <> string.inspect(tcp)
      <> ", port="
      <> string.inspect(port)
      <> ", msg="
      <> message,
  )

  // sleep so we can ensure the logs print to the console
  process.sleep(500)

  logging.log(logging.Info, "------------------------------------------------")
  logging.log(logging.Info, "passive socket")
  logging.log(logging.Info, "------------------------------------------------")

  // goal:04: send/receive with socket mode = passive
  let assert Ok(socket) =
    connect("tcpbin.com", 4242, [atom.create("binary")], False, 1000)
  logging.log(logging.Info, string.inspect(socket))
  logging.log(logging.Info, "passive socket send: " <> hw)
  let assert Ok(Nil) =
    send(socket, bytes_tree.from_bit_array(bit_array.from_string(hw)))

  logging.log(logging.Info, "check passive socket...")
  let assert Ok(result) = recv(socket, 0, 1000)

  logging.log(logging.Info, "passive socket received:" <> string.inspect(result))

  // sleep so we can ensure the logs print to the console
  process.sleep(100)
}
