.PHONY: ci ac autocorrect lint test

ci: lint
ac: autocorrect

lint:
	git ls-files "*.rb" "*Rakefile" "*Gemfile" ":(exclude)test/bundle" -z |\
		xargs -0 rubocop

autocorrect:
	git ls-files "*.rb" "*Rakefile" "*Gemfile" ":(exclude)test/bundle" -z |\
		xargs -0 rubocop -a

test:
	./test/run_tests.sh

bundle_update:
	cd ./test/ &&\
		bundle update &&\
		bundle clean &&\
		bundle install --standalone
