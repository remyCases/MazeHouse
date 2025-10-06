# Lighthouse Maze

A puzzle game made for Trijam with the theme "Lighthouse" (developed in ~10 hours).

## About

Navigate through procedurally generated mazes while collecting white squares. An enemy lighthouse patrols the area with rotating light cones above and below it.
If you're caught in the light and move, you lose!

## Technical Details

Built with Godot Engine (GDScript)

### Maze Generation

Uses a modified backtracking algorithm (growing tree variant) to create the maze layouts. [Details can be found here](https://weblog.jamisbuck.org/2011/1/27/maze-generation-growing-tree-algorithm).

### Collectible Placement

Implements a Poisson point process with selection sampling. While the intensity parameter remains constant, the sampling algorithm introduces conditional dependencies between points, creating a non-homogeneous spatial distribution.

## Controls

Arrow Keys or WASD: Move
Controller (recommended for best experience)

## Play

It can be played directly in browser or download (Windows only) [from the itch.io page](https://zizani.itch.io/mazehouse).
