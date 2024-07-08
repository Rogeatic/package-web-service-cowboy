-module(location_update_h).

-export([init/2]).

init(Req0, Opts) ->
       {ok, Data,_} = cowboy_req:read_body(Req0),

       % FIX THIS LINE and include jsx
       % {Location_id, Package_id}
       DataReceived = jsx:decode(Data),

       LocationId = maps:get(<<"location_id">>, DataReceived),
       Longitude = maps:get(<<"long">>, DataReceived),
       Latitude = maps:get(<<"lat">>, DataReceived),
       io:format("Location ID: ~p, Longitude: ~p, Latitude: ~p~n", [LocationId, Longitude, Latitude]),
   

       io:format("~s~n", [jsx:encode(DataReceived)]),
       Indicator = case erpc:call('bus@businesslogic.williamsonline.net', 'package_server', 'update_location', [LocationId, Longitude, Latitude]) of 
              worked -> 200;
              _ -> 500
              end,
       Req = cowboy_req:reply(Indicator, #{ <<"content-type">> => <<"text/plain">>}),

       {ok, Req, Opts}.