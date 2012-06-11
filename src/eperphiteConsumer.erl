-module(eperphiteConsumer).
-export([init/1, terminate/1, tick/2, collectors/0, config/2]).

-record(cld, {}).

collectors() -> [prfSys].
init(_Node) -> #cld{}.
terminate(_LD) -> ok.

config(LD,_) -> LD.

tick(LD,Data) ->
  case Data of
    [{prfSys,PrfSys}] -> to_estatsd(PrfSys), LD;
    _ -> LD
  end.

to_estatsd(PrfSys) ->
  PrfSys1 = lists:keydelete(now, 1, PrfSys),
  {value, {node, Node}, PrfSys2} = lists:keytake(node, 1, PrfSys1),
  NodeKey = "eper." ++ node_key(Node),
  F = fun({K,V}) ->
          Id = NodeKey ++ atom_to_list(K),
          estatsd:gauge(Id, V)
      end,
  lists:foreach(F, PrfSys2),
  ok.

node_key(Node) ->
    NodeList = atom_to_list(Node),
    {ok, R} = re:compile("[\@\.]"),
    Opts = [global, {return, list}],
    S = re:replace(NodeList,  R, "_", Opts),
    S.
