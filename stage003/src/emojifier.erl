-module emojifier.

-behaviour application.

-export [start/2, stop/1].
-export [emojify/1, add/2].

start(_, noargs) ->
    emojifier_sup:start_link().

stop(nostate) -> ok.

emojify(String) -> emojifier_wrk:emojify(String).

add(Text, Emoji) -> emojifier_wrk:add(Text, Emoji).
