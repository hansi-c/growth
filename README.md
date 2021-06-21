# L Systems

Lindenmayer Systems implemented in the Godot game engine.

## growth

The project began as a contribution to Godot Game Jam 2021. https://gogodotjam.com/

The theme for the jam was growth. We used an L System to grow a plant.

The original submission can be seen here: https://yongu.itch.io/twigs (runs in browser but not on mobile)

## Current project

We kept extending the gamejam submission. The code is heavily based on this paper: http://algorithmicbotany.org/papers/hanan.dis1992.pdf

You can try out the current version here: https://yongu.itch.io/l-systems?secret=TTrvfLagm8k8kMKYoiKrySGLo

Since we don't have an automated deployment process (yet), the playable version might be behind a few commits.

### Existing features

+ Accepts context-sensitive grammars (only left context so far. right context will follow)
+ Accepts stochastic grammars. The same symbol may be assigned multiple successors. One of them is chosen according to their probability factors. 

### Planned features

+ Parametric L Systems. Allows passing parameters to productions.
+ A grammar editor at runtime. For now, grammars are written in code. In the future, users will be able to write their own grammars.
