! Copyright (C) 2011 Fred Alger.
! See http://factorcode.org/license.txt for BSD license.
USING: kernel locals math math.parser sequences splitting
unicode.categories zeromq json.reader ;
IN: mongrel2

TUPLE: handler-request sender-id client-id path headers body ;

: read-netstring ( str -- rest str )
    ":" split1-slice dup length 0 >
    [ swap string>number [ 1 + tail ] [ head ] 2bi ]
    [ 2drop f "" ] if ;

: read-netstrings ( str -- seq )
    [ dup ]
    [ read-netstring ] produce nip ;

: extract-payload ( str payload-prefix -- headers body )
    over start tail-slice read-netstrings [ first json> ] [ second ] bi  ;

:: read-request-parts ( str -- sender-id client-id path headers body )
    str " " split
    [ first3 ]
    [ fourth str swap extract-payload ] bi ;

: <handler-request> ( str -- req )
    read-request-parts handler-request boa ;
