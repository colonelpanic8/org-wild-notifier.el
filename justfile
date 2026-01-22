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

# Clean build artifacts
clean:
    rm -f *.elc tests/*.elc
    rm -rf result
