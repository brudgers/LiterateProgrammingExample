#lang scribble/manual
@(require(for-label 2htdp/image))
@require[scribble/lp-include]
@title{Literate Programming Example}
You are looking at the results of recent experiments with Literate
Programming in Racket. The name of the file you're reading is
@code{LPexample.scrbl}. It's a wrapper around the real substance of
this program, which is in the included file @code{LPexample.rkt}.
@lp-include["LPexample.rkt"]
