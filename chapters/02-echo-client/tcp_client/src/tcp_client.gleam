import gleam/string
import gleam/int
import logging
import gleam/erlang/process.{type Subject}
import gleam/otp/actor

pub fn main() {
  logging.configure()
  logging.log(logging.Info, "main")

  let my_actor_name = process.new_name("foo")

  // Start an actor
  let assert Ok(my_actor) =
    actor.new(0)
    |> actor.named(my_actor_name)
    |> actor.on_message(handle_message)
    |> actor.start

  let sub = my_actor.data

  // Send some messages to the actor
  logging.log(logging.Info, "send Add5")
  actor.send(sub, Add(5))
  logging.log(logging.Info, "send Add3")
  actor.send(sub, Add(3))

  // Send a message and get a reply
  logging.log(logging.Info, "call Get")
  assert actor.call(sub, waiting: 10, sending: Get) == 8

  logging.log(logging.Info, "call Echo")
  assert actor.call(sub, waiting: 10, sending: Echo(_, #("a", "b"))) == #("a", "b")
//  process.sleep_forever()
  process.sleep(2000)
}

pub fn handle_message(state: Int, message: Message) -> actor.Next(Int, Message) {
  case message {
    Add(i) -> {
      let state = state + i
      logging.log(logging.Info, "handle message Add: " <> int.to_string(state))
      actor.continue(state)
    }
    Get(reply) -> {
      logging.log(logging.Info, "handle message Get: " <> int.to_string(state))
      actor.send(reply, state)
      actor.continue(state)
    }
    Echo(reply, data) -> {
      logging.log(logging.Info, "handle message Echo: " <> string.inspect(reply))
      actor.send(reply, data)
      actor.continue(state)
    }
  }
}

pub type Blarg = #(String, String)

pub type Message {
  Add(Int)
  Get(Subject(Int))
  Echo(reply_to: Subject(Blarg), data: Blarg)
}