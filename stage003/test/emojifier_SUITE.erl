-module emojifier_SUITE.

-behaviour ct_suite.

-export [all/0, init_per_testcase/2, end_per_testcase/2].
-export [app/1, complete_coverage/1, emojify/1].

all() -> [app, complete_coverage, emojify].

app(_) ->
    {ok, [emojifier]} = application:ensure_all_started(emojifier),
    ok = application:stop(emojifier).

complete_coverage(_) ->
    _ = emojifier:stop(nostate).

emojify(_) ->
    "" = emojifier:emojify(""),
    "Same String" = emojifier:emojify("Same String"),
    _ = emojifier:add(":smile:", "😊"),
    "With 😊" = emojifier:emojify("With :smile:"),
    "No :smile" = emojifier:emojify("No :smile"),
    _ = emojifier:add(":mate:", "🧉"),
    "With 😊 and 🧉" = emojifier:emojify("With :smile: and :mate:"),
    "With 2 🧉🧉" = emojifier:emojify("With 2 :mate::mate:"),
    ok.

init_per_testcase(emojify, Config) ->
    {ok, _} = application:ensure_all_started(emojifier),
    Config;
init_per_testcase(_, Config) -> Config.

end_per_testcase(emojify, Config) ->
    _ = application:stop(emojifier),
    Config;
end_per_testcase(_, Config) -> Config.
