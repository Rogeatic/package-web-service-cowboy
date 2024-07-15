-module(location_update_h).

-export([init/2]).

init(Req0, Opts) ->
       {ok, Data,_} = cowboy_req:read_body(Req0),
       DataReceived = jsx:decode(Data),
       LocationId = maps:get(<<"location_id">>, DataReceived),
       Longitude = maps:get(<<"long">>, DataReceived),
       Latitude = maps:get(<<"lat">>, DataReceived),
       Indicator = case erpc:call('bus@businesslogic.williamsonline.net', 'package_server', 'update_location', [LocationId, Longitude, Latitude]) of 
              worked -> 200;
              _ -> 500
              end,
       Req = cowboy_req:reply(Indicator, #{ <<"content-type">> => <<"text/plain">>}, Req0),

       {ok, Req, Opts}.