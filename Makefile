all:
	coffee -co lib src

clean:
	rm -rf lib

test: all
	mocha --reporter list
