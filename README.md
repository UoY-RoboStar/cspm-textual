cspm-textual
------------
This repository contains an Xtext grammar for CSPM that strictly follows that described in the FDR manual. 
It fully supports all the constructs of CSPM and contains a basic implementation of scopes following the
documentation for FDR. There is also basic support for validation, namely ensuring uniqueness of identifiers.

## Limitations
There is currently no explicit support for handling `include` directives and performing validation across
multiple resources. There is also no type-checking implemented.
