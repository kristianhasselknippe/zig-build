(require 'transient)

(defmacro define-zig-build-infix (name description short arg)
  `(define-infix-argument ,(intern (format "zig-build:%s" name)) ()
	 :description ,description
	 :class 'transient-option
	 :shortarg ,short
	 :argument ,(format "%s " arg)))

(defun run-zig-build-command (&rest args)
  (interactive (transient-args))
  (compile (format "zig build %s" (string-join args " "))))

(defun run-zig-run-command (&rest args)
  (interactive (transient-args))
  (compile (format "zig build run %s" (string-join args " "))))

(define-infix-argument zig-compile:--c-source (options file)
  :description "compile C source code"
  :class 'transient-option
  :shortarg "-argument"
  :argument "--message=")

(defmacro define-zig-compile-option (option message args body)
  `(define-infix-argument zig-compile:,option ,args
  :description "compile C source code"
  :class 'transient-option
  :shortarg "-m"
  :argument "--message="))

(define-zig-build-infix "--prefix" "Override default install prefix, libraries, headers" "-p" "--prefix")
(define-zig-build-infix "--search-prefix" "Add a path to look for binaries, libraries, headers" "-P" "--search-prefix")

(define-zig-build-infix "--build-file" "Override path to build.zig" "-B" "--build-file")
(define-zig-build-infix "--cache-dir" "Override path to zig cache directory" "-B" "--cache-dir")
(define-zig-build-infix "--override-std-dir" "Override path to Zig standard library" "-o" "--override-std-dir")
(define-zig-build-infix "--override-lib-dir" "Override path to Zig lib directory" "-O" "--override-lib-dir")

(defun run-zig-fmt (filesArg)
  (call-process "zig" nil "*Zig fmt*" nil "fmt" filesArg))

(defun run-zig-fmt-file (&rest args)
  (interactive (transient-args))
  (run-zig-fmt (buffer-file-name)))

(defun run-zig-fmt-dir (&rest args)
  (interactive (transient-args))
  (run-zig-fmt (file-name-directory (buffer-file-name))))

(define-transient-command zig-fmt () "Zig fmt"
  ["Actions"
   ("f" "Format file" run-zig-fmt-file)
   ("d" "Format directory" run-zig-fmt-dir)])

(define-transient-command zig-build () "Zig build"
  ["General options"
   ("-v" "Print commands before executing them" "--verbose")
   (zig-build:--prefix)
   (zig-build:--search-prefix)]
  ["Project-Specifig Options"
   ("=s" "optimizatinos on and safety on" "-Drelease-safe=true")
   ("=f" "optimizations on and safety off" "-Drelease-fast=true")
   ("=S" "size optimizations on and safety off" "-Drelease-small=true")]
  ["Advanced options"
   (zig-build:--build-file)
   (zig-build:--cache-dir)
   (zig-build:--override-std-dir)
   (zig-build:--override-lib-dir)
   ("@t" "Enable compiler debug output for tokenization" "--verbose-tokenize")
   ("@a" "Enable compiler debug output for parsing into an AST" "--verbose-ast")
   ("@l" "Enable compiler debug output for linking" "--verbose-link")
   ("@i" "Enable compiler debug output for Zig IR" "--verbose-ir")
   ("@L" "Enable compiler debug output for LLVM IR" "--verbose-llvm-ir")
   ("@c" "Enable compiler debug output for C imports" "--verbose-cimport")
   ("@C" "Enable compiler debug output for C compilation" "--verbose-cc")]
  ["Actions"
   ("b" "Build (install)" run-zig-build-command)
   ("r" "Run" run-zig-run-command)])
