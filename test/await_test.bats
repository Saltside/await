#!/usr/bin/env bats

@test "successful redis connection" {
	run await redis -r 5 redis://redis
	[ $status -eq 0 ]
}

@test "unsuccessful redis connection" {
	run await redis -r 1 redis://unknown
	[ $status -eq 1 ]
}

@test "successful mongodb connection" {
	run await mongodb -r 5 mongodb://mongodb
	[ $status -eq 0 ]
}

@test "unsuccessful mongodb connection" {
	run await mongodb -r 1 mongodb://unknown
	[ $status -eq 1 ]
}

@test "successful http connection" {
	run await http -r 5 http://http
	[ $status -eq 0 ]
}

@test "successful http connection with extra parameters" {
	run await http -r 2 -- http://http -m 5
	[ $status -eq 0 ]
}

@test "unsuccessful http connection" {
	run await http http://unknown
	[ $status -eq 1 ]
}

@test "unsuccessful http connection with retry" {
	run await http -r 1 http://unkown
	[ $status -eq 1 ]
}

@test "successful dynamodb connection" {
	run await dynamodb -- --endpoint-url "${DYNAMO_DB_URL}"
	[ $status -eq 0 ]
}

@test "successful dynamodb connection with retry" {
	run await dynamodb -r 2 -- --endpoint-url "${DYNAMO_DB_URL}"
	[ $status -eq 0 ]
}

@test "unsuccessful dynamodb connection with retry" {
	run await dynamodb -r 1 -- --endpoint-url "http://junk:8080" --cli-connect-timeout 5
	[ $status -eq 1 ]
}

@test "successful mysql connection with retry" {
	run await mysql -r 5 mysql://root:secret@mysql:3306
	[ $status -eq 0 ]
}

@test "unsuccessful mysql connection with retry" {
	run await mysql -r 1 mysql://unknown
	[ $status -eq 1 ]
}

@test "successful memcached connection with retry" {
	run await memcached -h memcached -r 2
	[ $status -eq 0 ]
}

@test "unsuccessful memcached connection with retry" {
	run await memcached -h junk -r 2
	[ $status -eq 1 ]
}
