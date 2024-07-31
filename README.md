cspm-textual
------------
This repository contains an Xtext grammar for CSPM that strictly follows that described in the FDR manual. 
It fully supports all the constructs of CSPM and contains a basic implementation of scopes following the
documentation for FDR. There is also basic support for validation, namely ensuring uniqueness of identifiers.

## Limitations
There is support for handling `include` directives, up to transitivity, however, we do not currently 
support the scenario where a `.csp` file can reference elements of an including file. For example, if `A.csp` 
references elements declared in `B.csp` and `B.csp` includes `A.csp`, while `B.csp` is valid on its own, 
`A.csp` is not, so errors will be flagged up for `A.csp`. Improvements to support this scenario are welcome.

Type-checking is also currently not implemented.
