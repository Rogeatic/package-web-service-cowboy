%%%-------------------------------------------------------------------
%% @doc package_web_service public API
%% @end
%%%-------------------------------------------------------------------

-module(package_web_service_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_Type, _Args) ->
    Dispatch = cowboy_router:compile([
        {'_', [
            {"/", default_page_h, []},
            {"/", default_page_h, []},
            {"/", default_page_h, []},
            {"/", default_page_h, []}
        ]}
    ]),

    PrivDir = code:priv_dir('package_web_service'),
    %tls stands for transport layer security
        {ok,_} = cowboy:start_tls(https_listener, [
                          {port, 443},
                {certfile, PrivDir ++ "/ssl/fullchain.pem"},
                {keyfile, PrivDir ++ "/ssl/privkey.pem"}
                      ], #{env => #{dispatch => Dispatch}}),
    package_web_service_sup:start_link().
stop(_State) ->
ok.         

%% internal functions
