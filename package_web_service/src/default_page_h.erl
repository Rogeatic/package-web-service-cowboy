%% @doc Hello world handler.
-module(default_page_h).

-export([init/2]).

init(Req0, Opts) ->
        Req = cowboy_req:reply(200, #{ <<"content-type">> => <<"text/plain">>}, "Hello world!", Req0),
        {ok, Req, Opts}.