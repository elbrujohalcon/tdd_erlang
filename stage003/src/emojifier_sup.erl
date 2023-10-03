-module emojifier_sup.

-behaviour supervisor.

-export [start_link/0, init/1].

start_link() ->
    supervisor:start_link(
        {local, emojifier_sup}, emojifier_sup, noargs).

init(noargs) ->
    {ok, {#{}, [
        #{id => worker, start => {emojifier_wrk, start_link, []}}
    ]}}.
