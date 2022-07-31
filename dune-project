(lang dune 3.3)

(name ox)

(generate_opam_files true)

(source
 (github ridho9/ox))

(authors "Ridho Pratama")

(license LICENSE)

(documentation https://url/to/documentation)

(package
 (name ox)
 (synopsis "A short synopsis")
 (description "A longer description")
 (depends ocaml dune)
 (tags
  (topics "to describe" your project)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project

(using menhir 2.1)
