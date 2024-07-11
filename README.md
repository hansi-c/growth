# L Systems

[Lindenmayer Systems](https://en.wikipedia.org/wiki/L-system) implemented in the [Godot engine](https://godotengine.org).

You can try out the latest version here: https://yongu.itch.io/l-systems \
(Runs best on a computer with a mouse. Touchscreen support is bad.)

## Growth

The project began as a contribution to [Godot Game Jam 2021](https://gogodotjam.com/). The theme for the jam was Growth. We used an L System to grow a plant.

The original submission can be seen here: https://yongu.itch.io/twigs (runs in browser but not on mobile)

We kept extending the gamejam submission. The code is heavily based on this paper: http://algorithmicbotany.org/papers/hanan.dis1992.pdf

### Features

+ A grammar editor at runtime. Users are able to write their own grammars and test them immediately.
+ Accepts context-sensitive grammars. Productions are applied only if their left context matches the symbols before the current position. Right context is not implemented.
+ Accepts stochastic grammars. The same symbol may be assigned multiple successors, each with their own probability. One of them is chosen at random by the weighted probabilities.

### Roadmap

+ Export and import function. Write L Systems to files and load them from files. Share your creations with others!
+ Random grammar generator. Generate random grammars in mass production, write them to file and view them. Requires export/import function.
+ Right context sensitivity.
+ Parametric L Systems. Allows passing parameters to productions.
