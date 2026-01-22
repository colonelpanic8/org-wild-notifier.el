# Run tests (assumes direnv/nix shell is active)
test:
    emacs --batch \
        -L . \
        -L tests \
        -l ert \
        -l tests/org-wild-notifier-tests.el \
        -f ert-run-tests-batch-and-exit

# Run tests via nix build (pure, reproducible)
test-nix:
    nix build .#test --print-build-logs

# Run a specific test
test-one TEST:
    emacs --batch \
        -L . \
        -L tests \
        -l ert \
        -l tests/org-wild-notifier-tests.el \
        --eval "(ert-run-tests-batch-and-exit '{{TEST}})"

# Byte-compile the package
byte-compile:
    emacs --batch -L . -f batch-byte-compile org-wild-notifier.el

# Run checkdoc
checkdoc:
    emacs --batch -L . -l org-wild-notifier.el \
        --eval "(checkdoc-file \"org-wild-notifier.el\")"

# Run package-lint
package-lint:
    emacs --batch -L . \
        --eval "(require 'package-lint)" \
        --eval "(setq package-lint-main-file \"org-wild-notifier.el\")" \
        -f package-lint-batch-and-exit org-wild-notifier.el

# Run all lint checks
lint: byte-compile checkdoc package-lint

# Run all checks (tests + lint)
check: test lint

# Clean build artifacts
clean:
    rm -f *.elc tests/*.elc
    rm -rf result
