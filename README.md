# 🎄 Advent Of Code 2019: Elixir 🎄

This repository contains solutions for the [Advent Of Code 2019](https://adventofcode.com/2019/) developed in [Elixir](https://elixir-lang.org/).

## Structure

For each day there's a corresponding mix project, each with it's own unique
name and roughly these contents:


* The README which contains the problems for both part one and part two for the specific day
* The input file
* The solution for part one
* The solution for part two

For example, on day one the solution is under `lib/rocket_equation.ex`
and you can run the solution using:

```
RocketEquation.part_one("input.txt")
```

For part one, for part two you can run instead:

```
RocketEquation.part_two("input.txt")
```

Note that `"input.txt"` is just the location of the input file for this day's
challenge.

Every day will follow the same structure so that you can easily look for the
solution and run the code.

Taking as example day 5 those files will be named `5.README.md`, `5.input.txt`, `5.1.exs` and `5.2.exs` respectively.

