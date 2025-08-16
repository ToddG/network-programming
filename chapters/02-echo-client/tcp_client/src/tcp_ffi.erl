-module(tcp_ffi).

-export([controlling_process/2, send/2, set_opts/2, shutdown/2, close/1, connect/5]).

send(Socket, Packet) ->
  case gen_tcp:send(Socket, Packet) of
    ok ->
      {ok, nil};
    Res ->
      Res
  end.

set_opts(Socket, Options) ->
  case inet:setopts(Socket, Options) of
    ok ->
      {ok, nil};
    {error, Reason} ->
      {error, Reason}
  end.

controlling_process(Socket, Pid) ->
  case gen_tcp:controlling_process(Socket, Pid) of
    ok ->
      {ok, nil};
    {error, Reason} ->
      {error, Reason}
  end.

shutdown(Socket, How) ->
  case gen_tcp:shutdown(Socket, How) of
    ok ->
      {ok, nil};
    {error, Reason} ->
      {error, Reason}
  end.

close(Socket) ->
  case gen_tcp:close(Socket) of
    ok ->
      {ok, nil};
    {error, Reason} ->
      {error, Reason}
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
