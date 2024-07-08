-module(location_request_h).

-export([init/2]).

init(Req0, Opts) ->
    {ok, Data,_} = cowboy_req:read_body(Req0),

    % FIX THIS LINE and include jsx
    % {Location_id, Package_id}
    DataRecieved = jsx:decode(Data),
    io:format("~s~n", [DataRecieved]),
    %Result = case 

    Req = cowboy_req:reply(200, #{
           <<"content-type">> => <<"text/plain">>
    }, "", Req0),
    {ok, Req, Opts}.