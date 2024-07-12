-module(delivered_h).

-export([init/2]).

init(Req0, Opts) ->
       {ok, Data,_} = cowboy_req:read_body(Req0),
       Package_id = jsx:decode(Data),
       
       io:format("Package ID: ~p~n", [Data]),
       io:format("~s~n", [jsx:encode(Package_id)]),
       io:format("~s~n", [Package_id]),
       io:format("~s~n", ["Hello World"]),


       Indicator = case erpc:call('bus@businesslogic.williamsonline.net', 'package_server', 'delivered', [Package_id]) of 
              worked -> 200;
              _ -> 500
              end,
       Req = cowboy_req:reply(Indicator, #{ <<"content-type">> => <<"text/plain">>}, Req0),

       {ok, Req, Opts}.