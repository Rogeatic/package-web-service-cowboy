-module(package_transferred_h).

-export([init/2]).

init(Req0, Opts) ->
       {ok, Data,_} = cowboy_req:read_body(Req0),
       DataRecieved = jsx:decode(Data),
       LocationId = maps:get(<<"location_id">>, DataRecieved),
       PackageId = maps:get(<<"package_id">>, DataRecieved),
       Indicator = case erpc:call('bus@businesslogic.williamsonline.net', 'package_server', 'transfer_package', [PackageId, LocationId]) of 
              worked -> 200;
              _ -> 500
              end,
       Req = cowboy_req:reply(Indicator, #{ <<"content-type">> => <<"text/plain">>}, Req0),

       {ok, Req, Opts}.