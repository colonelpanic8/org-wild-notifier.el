.PHONY: test test-nix clean

# Run tests using nix develop shell
test:
	nix develop -c emacs --batch \
		-L . \
		-L tests \
		-l ert \
		-l tests/org-wild-notifier-tests.el \
		-f ert-run-tests-batch-and-exit

# Run tests via nix build (pure, reproducible)
test-nix:
	nix build .#test --print-build-logs

# Run a specific test
test-one:
	nix develop -c emacs --batch \
		-L . \
		-L tests \
		-l ert \
		-l tests/org-wild-notifier-tests.el \
		--eval "(ert-run-tests-batch-and-exit '$(TEST))"

clean:
	rm -f *.elc tests/*.elc
	rm -rf result
