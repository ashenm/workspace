default:
	$(MAKE) build
	$(MAKE) run

build:
	./scripts/build.sh

run:
	./scripts/run.sh --dev --dry

purge:
	./scripts/clean.sh --all

assess:
	./scripts/assess.sh

clean:
	./scripts/clean.sh

