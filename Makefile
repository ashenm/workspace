default:
	$(MAKE) build
	$(MAKE) run

build:
	./scripts/build.sh

run:
	./scripts/run.sh --dev --dry

purge:
	./scripts/clean.sh --all

clean:
	./scripts/clean.sh

