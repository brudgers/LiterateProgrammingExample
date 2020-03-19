#lang scribble/lp2

@code{LPexample.rkt} is the source file for this document. The Github repository
is @link["https://github.com/brudgers/LiterateProgrammingExample"]{here}.

@section{Introduction}

Racket's @code{#lang scribble/lp} and @code{#lang scribble/lp2} let us write
programs in the @emph{Literate Programming Idiom}. In that idiom, we write
@emph{documents about our code}, presented in an order convenient for humans.
Automated tools rearrange or @emph{tangle} the code up into an order convenient
for the computer. Only with literate programming do you have complete freedom to
refer to things before you define them or define them before you refer to them
in whatever order makes it easiest for you to explain to other humans and for
those humans to understand what you write.

@section{How to Do It}

Racket's official documentation on @code{#lang scribble/lp} and @code{#lang
scribble/lp2} is not very clear, however, and that's not surprising: racket's
official documentation is sometimes lacking for features outside the core or for
topics between the very basic and detailed reference.

You can do two different things with a literate program: @emph{tangle} it or
@emph{weave} it. Tangling a literate program means either just running it or
spreading its code out on disk in a structure convenient for build tools.
Weaving a literate program means rendering it to @code{HTML}, @code{LaTeX}, or
@code{PDF}, specifically for human consumption.

Because we want to @emph{run} our programs, we must use the file extension
@code{.rkt}, not @code{.scrbl}, for literate programs. You can run this here
@code{.rkt}, the one you're reading right now, by typing

@commandline{racket LPexample.rkt}

at the command line, or by clicking the ``Run'' button when you have the file
open in the DrRacket GUI. It's probably better to run the program in the GUI
because the program draws pictures that you can't see in the command line, but
it's fine either way.

@section{Weaving, or Producing Documentation}

Racket's @code{scribble} command does weaving. You can

@commandline{scribble --pdf LPexample.rkt}

if you want to do, but the result is ugly. It's much better to wrap this
@code{.rkt} file in a @code{.scrbl} file written in either @code{#lang
scribble/base} or @code{#lang scribble/manual}, both of which make pretty
output. The @code{.scrbl} wrapper should be very basic:

@verbatim|{#lang scribble/manual
           @(require(for-label 2htdp/image))
           @require[scribble/lp-include]
           @title{Literate Programming Example}
           You are looking at the results of recent experiments with Literate
           Programming in Racket. The name of the file you're reading is
           @code{LPexample.scrbl}. It's a wrapper around the real substance of
           this program, which is in the included file @code{LPexample.rkt}.
           @lp-include["LPexample.rkt"]}|

To weave @code{LPexample.rkt}, run the @code{scribble} command on its wrapper
@code{.scrbl} file.

@commandline|{scribble --pdf LPexample.scrbl}|

makes a @code{PDF} version, and

@commandline{scribble --html +m --redirect-main http://docs.racket-lang.org/ LPexample.scrbl}

makes a @code{HTML} version.

@section{Resolving External References}

Notice the first two @code{require} lines in the @code{.scrbl} wrapper file.

The first is @code{(require(for-label 2htdp/image))}, which sets the
@emph{documentation-phase} references. The @emph{documentation phase} is
analogous to the macro-expansion phase in Racket and other Lisps: it just
rewrites source code rather than compiling it.

The second is @code{require[scribble/lp-include]}, which empowers the weaver,
@code{scribble}, to include more files.

@section{Tangling}

A @code{scribble/lp} or @code{scribble/lp2} file, with @code{.rkt} extension,
contains both the code for @emph{tangling} and the text for
@emph{weaving} into a document.  Write code in @code{chunks}, like this:

@verbatim|{
@chunk[<example_main>
       <example_importExport>
       <example_body>]}|

Weaving with @code{scribble} makes that chunk look pretty:

@chunk[<example_main>
       <example_importExport>
       <example_body>]

The first line in any @code{chunk} form is the globally unique name of the chunk
you're defining, wrapped in angle brackets. The rest of the lines in a chunk
are either references (in angle brackets) to other chunks, or literal
code, as seen below.

Because @code{<example_main>} is the first chunk in the @code{.rkt} file, Racket
treats it as the @emph{main chunk}. That fact is mentioned briefly near the
bottom of the
@link["http://docs.racket-lang.org/scribble/lp.html"]{@code{scribble/lp}
documentation}. If you don't want the first @code{chunk} to be the main chunk,
then, anywhere in the document write a chunk with the special name @code{<*>}:

@verbatim|{
@chunk[<*>
       <example_importExport>
       <example_body>]}|

That will be the main chunk. You may have zero or one chunks named @code{<*>}.
If you have zero, then the first chunk in the file is the main chunk. If you
have one, then none of your chunks depend on position, and that's a nice property.

In any event, with literate programming, you present your code in an order
convenient for humans. You may define before referring, or you may refer before
defining. Non-literate programming doesn't let you refer before defining, usually.

Tangling puts code in the order required for the compiler or interpreter, that
is, for Racket. For instance, Racket needs @code{require} and @code{provide}
statements near the top, and either of @code{main-chunk} forms above references
a certain chunk named @code{<example_importExport>} before all other references.
That chunk contains literal code for the @code{require} and @code{provide}
statements. You may position the definition of that chunk anywhere you like
inside the @code{.rkt} file. Let's define it now. You write:

@verbatim|{
@chunk[<example_importExport>
       (require 2htdp/image)
       (provide (all-defined-out))]}|

and the weaver, @code{scribble}, makes it pretty:

@chunk[<example_importExport>
       (require 2htdp/image)
       (provide (all-defined-out))]

In that example, we referred to the chunk named @code{<example_importExport>>}
before we defined it. Now, let's define one before we use it. You write:

@verbatim|{
@chunk[<blue_square>
       (rectangle 100 100 "solid" "blue")}|

and the weaver makes it pretty:

@chunk[<blue_square>
       (rectangle 100 100 "solid" "blue")]

Now, compose @code{<blue_square>} into another code block. You write:

@verbatim|{
@chunk[<example_body>
       (beside/align "bottom"
              (ellipse 20 70 "solid" "lightsteelblue")
              <blue_square>)]}|

and the weaver makes it pretty:

@chunk[<example_body>
       (beside/align "bottom"
              (ellipse 20 70 "solid" "lightsteelblue")
              <blue_square>)]

There we go. It's all bottomed out, and you can run (tangle) this file or
scribble (weave) it.

@include-section["milk.rkt"]

@section{Conclusions}

We teased  out two things from the documentation:

@itemlist[@item{The @code{.scrbl} file for weaving in @code{#lang manual} is a
wrapper around @code{.rkt} file in @code{#lang scribble/lp} or @code{#lang
scribble/lp}. The @code{.scrbl} file loads the wrapped @code{.rkt} file via
@code{lp-include}.}

@item{Tangling treats the first chunk differently unless the @code{<*>} special
name exists in the file.}]

Happy Literate Programming, Ben.

Update: 3/19/20 - Brian Beckman wordsmithed and did some experiments with
including.

Update: 13/12/19 - broken links issue fixed and documented thanks to
StackOverflow user Asumu Takikawa.
