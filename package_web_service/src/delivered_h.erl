-module(delivered_h).

-export([init/2]).

init(Req0, Opts) ->
       {ok, Data,_} = cowboy_req:read_body(Req0),
       DataRecieved = jsx:decode(Data),
       PackageId = maps:get(<<"package_id">>, DataRecieved),
       
       io:format("Package ID: ~p~n", [PackageId]),
       io:format("~s~n", [jsx:encode(DataRecieved)]),
       Indicator = case erpc:call('bus@businesslogic.williamsonline.net', 'package_server', 'delivered', [PackageId]) of 
              worked -> 200;
              _ -> 500
              end,
       Req = cowboy_req:reply(Indicator, #{ <<"content-type">> => <<"text/plain">>}, Req0),

       {ok, Req, Opts}.