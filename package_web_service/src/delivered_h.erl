-module(delivered_h).

-export([init/2]).

init(Req0, Opts) ->
    {ok, Data,_} = cowboy_req:read_body(Req0),

    DataRecieved = jsx:decode(Data),
    io:format("~s~n", [DataRecieved]),

    Req = cowboy_req:reply(200, #{ <<"content-type">> => <<"text/plain">>}, "", Req0),
    {ok, Req, Opts}.