#!/usr/bin/env bats

@test "successful redis connection" {
	run await redis -h redis -r 5
	[ $status -eq 0 ]
}

@test "unsuccessful redis connection" {
	run await redis -h junk -r 1
	[ $status -eq 1 ]
}

@test "successful mongodb connection" {
	run await mongodb -h mongodb -r 5
	[ $status -eq 0 ]
}

@test "unsuccessful mongodb connection" {
	run await mongodb -h junk -r 1
	[ $status -eq 1 ]
}

@test "successful http connection" {
	run await http -h http -r 5
	[ $status -eq 0 ]
}

@test "successful http connection with extra parameters" {
	run await http -h http -r 2 -- -m 5
	[ $status -eq 0 ]
}

@test "unsuccessful http connection" {
	run await http -h junk -r 1
	[ $status -eq 1 ]
}

@test "unsuccessful http connection with retry" {
	run await http -h junk -r 1
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
	run await mysql -h mysql -r 5 -- --user=root --password=secret mydb
	[ $status -eq 0 ]
}

@test "unsuccessful mysql connection with retry" {
	run await mysql -r 1 -h junk
	[ $status -eq 1 ]
}
