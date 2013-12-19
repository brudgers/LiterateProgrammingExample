#lang scribble/lp


@code{LPexample.rkt} is the source file for this document



@section{Introduction}

Racket's @code{scribble/lp} language allows programs to be written in the Literate Programming Idiom. The documentation, however, is not very clear. This should not be particularly surprising because Racket's documentation is sometimes lacking when it comes to features outside the core and when something between very basic material and detailed reference is needed.

@section{Weaving}

The process of weaving is where @code{scribble/lp} is a bit confusing.  Unlike documents in @code{scribble/base} or @code{scribble/manual}, documents written in @code{scribble/lp} cannot be directly rendered to @code{HTML} or @code{LaTeX}. This is why DrRacket does not provide "the easy button" when it sees a @code{scribble/lp} document.

Documents written using @code{#lang scribble/lp} use the file extension @code{.rkt} not @code{.scrbl}.

This means that a Racket Literate Program requires a second document written in either @code{scribble/base} or @code{scribble/manual}. This can be very basic:
@verbatim|{
           @(require(for-label 2htdp/image))
           @require[scribble/lp-include]
           @title{Literate Programming Example}
           This is the result of my recent research on Literate Programming in Racket. The name of this file is @code{LPexample.scrbl}. It's not perfect as I still have not solved the problem of broken links, but I'm working on it.
           @lp-include["LPexample.rkt"]}|

The file for weaving has a file extension of @code{.scrbl}. To weave @code{LPexample.rkt} we run the @code{scribble} command on its corresponding @code{.scrbl} file. In this case: @code{LPexample.scrbl}.

Resolving the external references has two parts.

@itemlist[@item{The first is @code{(require(for-label 2htdp/image))} which sets the @emph{documentation phase} references. The @emph{documentation phase} in Racket is analogous to the expansion phase for macros in Racket and other Lisps in that it just focuses on modifying the source code rather than compiling it.}                                                            @item{The second step is calling the scribble command with the appropriate flags. The command to weave this document is: @commandline{scribble --html +m --redirect-main http://docs.racket-lang.org/ LPexample.scrbl}}]



@section{Tangling}

A @code{scribble/lp} file contains both the code for @emph{tangling} into a program or library and the text for @emph{weaving} into a document. Like its parent @code{scribble}, @code{scribble/lp} allows direct input of text. The code to be tangled is deliniated: 
@verbatim|{
@chunk[<example_main>
       <example_requires>
       <example_exports>
       <example_body>]}|

Which matches the source for this output from the weaving proccess:

@chunk[<example_main>
       <example_importExport>
       <example_body>]

Beacuse this is the first @verbatim|{@chunk}| it is treated as the @emph{main chunk}. This is mentioned briefly near the bottom of the @link["http://docs.racket-lang.org/scribble/lp.html"]{@code{scribble/lp} documentation}. If you don't want the first @verbatim|{@chunk}| to serve as the main chunk, then: 

@verbatim|{
@chunk[<*>
       <example_requires>
       <example_exports>
       <example_body>]}|

can be placed anywhere in the document to serve as the main chunk. Having tried it, it really doesn't add anything for clarity and is unnessary.

The reason it is unnessary is that tangling can entail composing the code in a sequence other than what would normally be used in a @code{#lang racket} program. For example, required modules need not be near the top. This chunk:

@verbatim|{
@chunk[<example_importExport>
       (require 2htdp/image)
       (provide (all-defined-out))]}|

produces, this output from the weaving process:

@chunk[<example_importExport>
       (require 2htdp/image)
       (provide (all-defined-out))]

As shown in the example, source chunks like this:
@verbatim|{
@chunk[<blue_square>
(rectangle 100 100 "solid" "blue")}|

which weaves to this:

@chunk[<blue_square>
       (rectangle 100 100 "solid" "blue")]

can be composed into other functions this way:
@verbatim|{
@chunk[<blue_square>
(beside/align "bottom"
              (ellipse 20 70 "solid" "lightsteelblue")
              <blue_square>)]}|

which weaves out to:

@chunk[<example_body>
(beside/align "bottom"
              (ellipse 20 70 "solid" "lightsteelblue")
              <blue_square>)]

@section{Conclusions}

The two items which required teasing out from the documentation are:
@itemlist[@item{Weaving requires a second file where a file with a @code{.rkt} file extension is referenced using @code{lp-include}.}
           @item{Tangling treats the first chunk differently unless the @code{<*>} special name is used.}]

Lastly, it is still unclear to me how to resolve broken references easily. But I'm working on it and I will let you know. Happy Literate Programming, Ben.

Update: 13/12/19 - broken links issue fixed and documented thanks to StackOverflow user Asumu Takikawa.
                                                                        
                                                                      






                                                                                                                                                                                                                                                                                  
