.PHONY: deps seed run test build docs lint clean

deps:
	dbt deps

seed:
	dbt seed

run:
	dbt run

test:
	dbt test

build:
	dbt build

docs:
	dbt docs generate && dbt docs serve

lint:
	sqlfluff lint models tests macros

clean:
	dbt clean
	rm -rf target dbt_packages logs
