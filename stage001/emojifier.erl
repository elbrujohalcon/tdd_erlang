-module emojifier.

-export [test/0].
-export [start/0, emojify/2, add/3].

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
    '✅'.

start() -> {ok, #{}}.

emojify(Emojis, String) ->
    lists:flatten(maps:fold(
        fun(Text, Emoji, AccString) ->
            string:replace(AccString, Text, Emoji, all)
        end, String, Emojis)).

add(Emojis, Text, Emoji) -> Emojis#{Text => Emoji}.
