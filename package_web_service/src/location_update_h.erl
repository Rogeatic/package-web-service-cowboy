-module(location_update_h).

-export([init/2]).

init(Req0, Opts) ->
       {ok, Data,_} = cowboy_req:read_body(Req0),

       % FIX THIS LINE and include jsx
       % {Location_id, Package_id}
       DataRecieved = jsx:decode(Data),
       io:format("~s~n", [jsx:encode(DataRecieved)]),
       Indicator = case erpc:call("bus@businesslogic.williamsonline.net", "package_server", "update_location", [
       maps:get(<<"location_id">>, DataRecieved),maps:get(<<"long">>, DataRecieved),  maps:get(<<"lat">>, DataRecieved)]) of 
              worked -> 200;
              _ -> 500
       end,
       Req = cowboy_req:reply(Indicator, #{ <<"content-type">> => <<"text/plain">>}),

       {ok, Req, Opts}.