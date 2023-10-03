-module emojifier_wrk.

-export [start_link/0, emojify/1, add/2].
-export [init/1, handle_call/3, handle_cast/2].

-behaviour gen_server.

start_link() ->
	gen_server:start_link(
    	{local, emojifier_wrk}, emojifier_wrk, noargs, []).

init(noargs) -> {ok, #{}}.

emojify(String) ->
    gen_server:call(emojifier_wrk, {emojify, String}).

handle_call({emojify, String}, _From, Emojis) ->
    {reply,
     lists:flatten(maps:fold(
        fun(Text, Emoji, AccString) ->
            string:replace(AccString, Text, Emoji, all)
        end, String, Emojis)),
     Emojis}.

add(Text, Emoji) ->
    gen_server:cast(emojifier_wrk, {add, Text, Emoji}).

handle_cast({add, Text, Emoji}, Emojis) ->
    {noreply, Emojis#{Text => Emoji}}.
