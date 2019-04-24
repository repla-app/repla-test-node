.PHONY: ci ac autocorrect lint test

ci: lint
ac: autocorrect

lint:
	rubocop

autocorrect:
	rubocop -a

test:
	./test/run_tests.sh

bundle_update:
	cd ./test/ &&\
		bundle update &&\
		bundle clean &&\
		bundle install --standalone
