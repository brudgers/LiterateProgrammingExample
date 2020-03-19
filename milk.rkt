#lang scribble/manual

@title{Including Other Files}

You can include text for weaving in side files. The text you're reading right
now is stored in a file named @code{"milk.rkt"}. I have found that chunks
defined in such files do not compose properly into the chunks in your primary
file, so it's not clear how to build up big programs from lots of little files.
We'll worry about that in the future.
