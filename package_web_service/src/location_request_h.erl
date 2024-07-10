-module(location_request_h).

-export([init/2]).

init(Req0, Opts) ->
       {ok, Data,_} = cowboy_req:read_body(Req0),
       Location_id_recieved = jsx:decode(Data),
       
       io:format("Location ID: ~p~n", [Location_id_recieved]),
       Req = case erpc:call('bus@businesslogic.williamsonline.net', 'package_server', 'location_request', [Location_id_recieved]) of 
              {worked, Long, Lat} ->
                     cowboy_req:reply(200, #{ <<"content-type">> => <<"text/plain">>}, jsx:encode({Long, Lat}), Req0);
              _ ->
                     cowboy_req:reply(500, #{ <<"content-type">> => <<"text/plain">>}, Req0)
              end,
       % returns {worked, Long, Lat}
       {ok, Req, Opts}.