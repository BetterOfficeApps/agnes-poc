.PHONY: default install lint

default:
	echo "Target required"

install:
	brew install tfenv
	tfenv install

lint:
	terraform fmt -check -diff -recursive
