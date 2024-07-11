# L Systems

[Lindenmayer Systems](https://en.wikipedia.org/wiki/L-system) implemented in the [Godot game engine](https://godotengine.org).

## growth

The project began as a contribution to [Godot Game Jam 2021](https://gogodotjam.com/).

The theme for the jam was growth. We used an L System to grow a plant.

The original submission can be seen here: https://yongu.itch.io/twigs (runs in browser but not on mobile)

## Current project

We kept extending the gamejam submission. The code is heavily based on this paper: http://algorithmicbotany.org/papers/hanan.dis1992.pdf

You can try out the latest version here: https://yongu.itch.io/l-systems?secret=TTrvfLagm8k8kMKYoiKrySGLo (Runs in web and also on mobile but only on Firefox, not Chrome. On my Android phone at least. Did not test any other browsers or systems.)

### Existing features

+ A grammar editor at runtime. Users are able to write their own grammars and test them immediately.
+ Accepts context-sensitive grammars. Productions are applied only if their left context matches the symbols before the current position. Right context is not implemented yet.
+ Accepts stochastic grammars. The same symbol may be assigned multiple successors, each with their own probability. One of them is chosen according to the weighted probabilities.

### Planned features

+ Parametric L Systems. Allows passing parameters to productions.
+ Export and import function. Write L Systems to files and load them from files. Share your creations with others!
+ Random grammar generator. Generate random grammars in mass production, write them to file and view them. Requires export/import function.
