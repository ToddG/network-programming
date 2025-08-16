-module(tcp_ffi).

-export([send/2, connect/5]).

send(Socket, Packet) ->
  case gen_tcp:send(Socket, Packet) of
    ok ->
      {ok, nil};
    Res ->
      Res
  end.

connect(Address, Port, Opts, Active, Timeout) ->
  Opts2 = [{active, Active}] ++ Opts,
  io:format("Address: ~p.\n", [Address]),
  AddressCharList = binary_to_list(Address),
  io:format("AddressCharList: ~p.\n", [AddressCharList]),
  io:format("Port: ~p.\n", [Port]),
  io:format("Opts: ~p.\n", [Opts2]),
  io:format("Timeout: ~p.\n", [Timeout]),
  gen_tcp:connect(AddressCharList, Port, Opts2, Timeout).
