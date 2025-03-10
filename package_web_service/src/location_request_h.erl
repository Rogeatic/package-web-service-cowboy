-module(location_request_h).

-export([init/2]).

init(Req0, Opts) ->
       {ok, Data,_} = cowboy_req:read_body(Req0),
       Package_id = jsx:decode(Data),

       Req = case erpc:call('bus@businesslogic.williamsonline.net', 'package_server', 'location_request', [Package_id]) of 
              {worked, Long, Lat} ->
                     cowboy_req:reply(200, #{ <<"content-type">> => <<"text/plain">>}, jsx:encode(#{<<"long">> => Long, <<"lat">> => Lat}), Req0);
              _ ->
                     cowboy_req:reply(500, #{ <<"content-type">> => <<"text/plain">>}, Req0)
              end,
       % returns {worked, Long, Lat}
       {ok, Req, Opts}.