all: compile
	bundle exec rake test

compile:
	bundle exec rake compile

doc:
	bundle exec yard
