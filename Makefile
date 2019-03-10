COMPILER=$(realpath gleam/target/release/gleam)

#
# Goals to be specified by user
#

.PHONY: build
build: book gleam gleam_stdlib/gen ## Build all targets

.PHONY: help
help:
	@cat $(MAKEFILE_LIST) | grep -E '^[a-zA-Z_-]+:.*?## .*$$' | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: gleam
gleam: gleam/target/release/gleam ## Build the Gleam compiler

.PHONY: book
book: docs/index.html ## Build the documentation

.PHONY: book-serve
book-serve: ## Run the book dev server
	cd book && mdbook serve --open

# Debug print vars with `make print-VAR_NAME`
print-%: ; @echo $*=$($*)

#
# Files
#

gleam_stdlib/gen: $(COMPILER) $(shell find gleam_stdlib -type f)
	rm -fr gleam_stdlib/gen
	$(COMPILER) build gleam_stdlib

$(COMPILER): $(shell find gleam/src -type f)
	cd gleam && cargo build --release

docs/index.html: $(shell find book/src -type f)
	rm -fr docs
	cd book && mdbook build --dest-dir ../docs/
