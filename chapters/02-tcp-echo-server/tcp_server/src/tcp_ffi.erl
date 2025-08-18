-module(tcp_ffi).

-export([listen/2]).


listen(Port, Opts) ->
  Opts2 = process_opts(Opts),
  io:format("Port: ~p, Opts: ~p.\n", [Port, Opts2]),
  gen_tcp:listen(Port, Opts2).


do_process_opt(Opt) ->
  case Opt of
    {mode, binary} -> binary;
    {active_mode, active} -> {active, true};
    {active_mode, passive} -> {active, false};
    {debug, true} -> {debug, true};
    _ -> error2
  end.

do_process_opts([Head | Tail], Acc) ->
  do_process_opts(Tail, [do_process_opt(Head)] ++ Acc);
do_process_opts([], Acc) -> Acc;
do_process_opts(_Opts, _Acc) ->
  error1.

process_opts(Opts) ->
  do_process_opts(Opts, []).
