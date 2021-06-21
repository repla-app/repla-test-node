.PHONY: ci ac autocorrect lint test gem_install

ci: gem_install lint
ac: autocorrect

lint:
	bundle exec rubocop

autocorrect:
	bundle exec rubocop -a

gem_install:
	bundle install --path vendor/bundle

test:
	./test/run_tests.sh

bundle_update:
	cd ./test/ &&\
		bundle update repla --full-index &&\
		bundle update &&\
		bundle clean &&\
		bundle install --standalone
