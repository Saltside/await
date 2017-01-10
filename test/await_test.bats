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

@test "unsuccessful http connection" {
	run await http -h junk -r 1
	[ $status -eq 1 ]
}

@test "unsuccessful http connection with timeout" {
	run await http -h junk -t 10 -r 1
	[ $status -eq 1 ]
}

@test "successful dynamodb connection" {
	run await dynamodb -- --endpoint-url "${DYNAMO_DB_URL}"
	[ $status -eq 0 ]
}

@test "successful dynamodb connection with timeout" {
	run await dynamodb -t 60 -- --endpoint-url "${DYNAMO_DB_URL}"
	[ $status -eq 0 ]
}

@test "unsuccessful dynamodb connection with timeout" {
	run await dynamodb -t 20 -- --endpoint-url "http://junk:8080"
	[ $status -eq 1 ]
}