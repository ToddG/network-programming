-module(tcp_ffi).

-export([listen/2]).


%%Opts: [{mode,binary},{active_mode,active}].
%%need to translate that to
%%[:binary, active: true]

%%https://www.erlang.org/doc/apps/kernel/gen_tcp.html

listen(Port, Opts) ->
  io:format("Port: ~p.\n", [Port]),
  io:format("Opts: ~p.\n", [Opts]),
  Opts2 = process_opts(Opts),
  io:format("Opts2: ~p.\n", [Opts2]),
  gen_tcp:listen(Port, Opts).


do_process_opt(Opt) ->
  io:format("Opt: ~p.\n", [Opt]),
  case Opt of
    {mode, binary} -> binary;
%%    {active_mode, active} -> {active: true};
    {active_mode, active} -> #{active => true};
    _ -> error2
  end.

do_process_opts([Head, Tail], Acc) ->
  io:format("do_process_opts: Head: ~p, Tail: ~p, Acum: ~p.\n", [Head, Tail, Acc]),
  do_process_opts([Tail], [do_process_opt(Head)] ++ Acc);
do_process_opts([Head], Acc) ->
  io:format("do_process_opts: Head: ~p, Acum: ~p.\n", [Head, Acc]),
  do_process_opts([], [do_process_opt(Head)] ++ Acc);
do_process_opts([], Acc) -> Acc;
do_process_opts(_Opts, _Acc) ->
  io:format("do_process_opts: _Opts: ~p, _Acc: ~p.\n", [_Opts, _Acc]),
  error1.

process_opts(Opts) ->
  io:format("process_opts: Opts: ~p.\n", [Opts]),
  [Head, Tail] = Opts,
  io:format("process_opts: Head: ~p.\n", [Head]),
  io:format("process_opts: Tail: ~p.\n", [Tail]),
  do_process_opts(Opts, []).

