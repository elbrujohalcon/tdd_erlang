-module emojifier.

-export [test/0].
-export [start/0, emojify/2, add/3].
-export [init/1, handle_call/3, handle_cast/2, handle_info/2].

-behaviour gen_server.

test() ->
    {ok, Emojifier0} = emojifier:start(),
    "" = emojifier:emojify(Emojifier0, ""),
    "Same String" = emojifier:emojify(Emojifier0, "Same String"),
    Emojifier1 = emojifier:add(Emojifier0, ":smile:", "😊"),
    "With 😊" = emojifier:emojify(Emojifier1, "With :smile:"),
    "No :smile" = emojifier:emojify(Emojifier1, "No :smile"),
    Emojifier2 = emojifier:add(Emojifier1, ":mate:", "🧉"),
    "With 😊 and 🧉" =
        emojifier:emojify(Emojifier2, "With :smile: and :mate:"),
    "With 2 🧉🧉" =
        emojifier:emojify(Emojifier2, "With 2 :mate::mate:"),
    complete_coverage(Emojifier2),
    '✅'.

complete_coverage(Emojifier) ->
    Emojifier ! {an, unexpected, messsage, '😱'}.

start() -> gen_server:start(emojifier, noargs, []).

init(noargs) -> {ok, #{}}.

emojify(Emojifier, String) ->
    gen_server:call(Emojifier, {emojify, String}).

handle_call({emojify, String}, _From, Emojis) ->
    {reply,
     lists:flatten(maps:fold(
        fun(Text, Emoji, AccString) ->
            string:replace(AccString, Text, Emoji, all)
        end, String, Emojis)),
     Emojis}.

add(Emojifier, Text, Emoji) ->
    gen_server:cast(Emojifier, {add, Text, Emoji}), Emojifier.

handle_cast({add, Text, Emoji}, Emojis) ->
    {noreply, Emojis#{Text => Emoji}}.

handle_info(_Msg, Emojis) -> {noreply, Emojis}.
