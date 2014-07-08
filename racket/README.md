racket macros
=============

Macros for racket:

Folders
-------
* config-lang --- Example of a small configuration language, using ***#lang S-exp***.
* convenience --- Macros for convenience as they are shorthands for something in Racket.
  * define-test --- Macro for writing contracts and tests together with ***(defines)*** in Racket.
  * getters.rkt --- Macro for writing accessors for list-based datatypes in one swoop.
  * human-time --- Macro for writing times in human-readable format and transforming it into seconds.
  * list-comprehensions --- haskell-style list comprehension wrapper around ***(for/list)***
* s-and-giggles --- Explorations in largely unnecessary stuff made just for the hell of it.
  * py-style --- Python-style for-loop (***for n in ns ...***)
  * while.rkt --- C-style ***while*** loop, with contracts for condition, etc.