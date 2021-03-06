Simplified JavaScript (SJS) is a JavaScript interpreter you can embed in your Flash ActionScript 3 projects.  It handles most JavaScript, and you can instantiate native flash objects like MovieClip with the "new" operator and manipulate them.  SJS is useful as an embedded scripting language for games or an exploratory debugging tool.

Inspirations: 

Douglas Crockford's "Top Down Operator Precedence"
http://javascript.crockford.com/tdop/tdop.html

Richard W.M. Jones' implementation of FORTH 
http://annexia.org/forth


How it works:

SJS operates on JavasScript in four stages:

1) Tokenize the source code.
  Lexer.as breaks the source code into a flat array of tokens like '{', 'while', '=', '!=', etc.
  This is just Douglas Crockford's lexer.

2) Parse the token array.
  Parser.as converts the token array into a tree of parse node objects, such that a preorder traversal
  of the tree, printing each node, would emit an arithemetic expression like 2 + 3 * 4
  in RPN, ie, 2 3 4 * +
  
3) Generate VM opcodes from the parse tree
  Parser.as walks the tree in preorder, calling the codegen method of each parse node, and storing
  the emitted VM opcodes.
  
  The parse tree can be dumped out in a representation that looks like a postfix LISP.
  This input:
    1 + 2 * 3 / 4 % 5
  would appear as:
    (+ 1 (% (/ (* 2 3) 4) 5))
  
4) Execute the opcodes.
  The VM iterates through the opcode array, modifying its own internal state in response to each one.
  It can also instantiate and perform method calls on Flash objects like MovieClip if they've been
  installed in its static member VM.registry:Object
  
  I use short human-readable strings to represent the opcodes, so we can easily read the generated
  code to make sure it's what's expected.
  
  This parse tree:
    (+ 1 (% (/ (* 2 3) 4) 5))
  Would generate this code:
    LIT 1 LIT 2 LIT 3 MUL LIT 4 DIV LIT 5 MOD ADD


SJS differs from JavaScript, mostly by omission:
  omitted keywords: delete typeof void as in instanceof is
  omitted control structures: for/in, switch/case, while at end of block (as in "{ ... } while(cond);")
  no prototype chain / inheritance
  logic:  a() && b()  will call both functions;  same for a() || b().
  semicolons are required
*/


Note for RemoteConsole.as:
		serve policy files on Flash's expected port 843 with:		
			while true ; cat policy.xml | nc -l 843 ; end
			
		listen for connections from the Flash app with:
			rlwrap nc -lk 8080
		
		better yet, run remote-console-hub.py, which provides a "chat" server 
		that stays up across multiple runs of your SWF. Connect to it and issue
		commands from Terminal with:

			rlwrap nc localhost 9000
		
		
		
		
