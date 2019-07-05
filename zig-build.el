(require 'transient)

(defun run-zig-build-command (&rest args)
  (interactive (transient-args))
  (message (format "zig build %s" (string-join args " "))))

(define-infix-argument zig-compile:--c-source (options file)
  :description "compile C source code"
  :class 'transient-option
  :shortarg "-m"
  :argument "--message=")

(defmacro define-zig-compile-option (option message args body)
  `(define-infix-argument zig-compile:,option ,args
  :description "compile C source code"
  :class 'transient-option
  :shortarg "-m"
  :argument "--message="))

(define-transient-command zig-build () "Zig build"
  ["Arguments"
   ("-v" "Print commands before executing them" "--verbose")
   (zig-build:--prefix)
   (zig-build:--search-prefix)]
  ["Actions"
   ("b" "Build" run-zig-build-command)])

(define-infix-argument zig-build:--prefix ()
  :description "Override default install prefix"
  :class 'transient-option
  :shortarg "-p"
  :argument "--prefix ")

(defmacro define-zig-build-infix (name description short arg)
  `(define-infix-argument ,(intern (format "zig-build:%s" name)) ()
	 :description ,description
	 :class 'transient-option
	 :shortarg ,short
	 :argument ,(format "%s " arg)))

(define-zig-build-infix "--search-prefix" "Add a path to look for binaries, libraries, headers" "-P" "--search-prefix")

;;General Options:
;;  --help                 Print this help and exit
;;  --verbose              Print commands before executing them
;;  --prefix [path]        Override default install prefix
;;  --search-prefix [path] Add a path to look for binaries, libraries, headers
;;
;;Project-Specific Options:
;;  -Drelease-safe=[bool]  optimizations on and safety on
;;  -Drelease-fast=[bool]  optimizations on and safety off
;;  -Drelease-small=[bool] size optimizations on and safety off
;;
;;Advanced Options:
;;  --build-file [file]      Override path to build.zig
;;  --cache-dir [path]       Override path to zig cache directory
;;  --override-std-dir [arg] Override path to Zig standard library
;;  --override-lib-dir [arg] Override path to Zig lib directory
;;  --verbose-tokenize       Enable compiler debug output for tokenization
;;  --verbose-ast            Enable compiler debug output for parsing into an AST
;;  --verbose-link           Enable compiler debug output for linking
;;  --verbose-ir             Enable compiler debug output for Zig IR
;;  --verbose-llvm-ir        Enable compiler debug output for LLVM IR
;;  --verbose-cimport        Enable compiler debug output for C imports
;;  --verbose-cc             Enable compiler debug output for C compilation


