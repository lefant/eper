-module(eperphite).
-export([start/0, start/1, start/2, stop/0]).

start() -> start(node()).

start([Node,Proxy]) ->
  application:start(estatsd),
  start(Node,Proxy);
start([Node]) -> start([Node,no_proxy]);
start(Node) -> start([Node]).

start(Node,Proxy) when is_atom(Node),is_atom(Proxy) ->
  prf:start(eperphite,Node,eperphiteConsumer,Proxy).

stop() -> prf:stop(eperphite).
