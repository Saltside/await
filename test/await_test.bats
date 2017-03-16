#!/usr/bin/env bats

@test "successful redis connection" {
	run await -r 5 -i 0.5 redis://redis
	[ $status -eq 0 ]
}

@test "unsuccessful redis connection" {
	run await -r 1 redis://unknown
	[ $status -eq 1 ]
}

@test "successful mongodb connection" {
	run await -r 5 -i 0.5 mongodb://mongodb
	[ $status -eq 0 ]
}

@test "unsuccessful mongodb connection" {
	run await -r 1 mongodb://unknown
	[ $status -eq 1 ]
}

@test "successful http connection" {
	run await -r 5 -i 0.5 http://http
	[ $status -eq 0 ]
}

@test "successful http connection with extra parameters" {
	run await -r 2 -i 0.5 -- http://http -m 5
	[ $status -eq 0 ]
}

@test "unsuccessful http connection" {
	run await http://unknown
	[ $status -eq 1 ]
}

@test "unsuccessful http connection" {
	run await -r 1 http://unkown
	[ $status -eq 1 ]
}

@test "successful dynamodb connection" {
	run await -r 2 -i 0.5 dynamodb://dynamodb:8000
	[ $status -eq 0 ]
}

@test "unsuccessful dynamodb connection with retry" {
	run await -r 2 dynamodb://unknown:8000
	[ $status -eq 1 ]
}

@test "successful mysql connection" {
	run await -r 5 -i 0.5 mysql://root:secret@mysql:3306
	[ $status -eq 0 ]
}

@test "unsuccessful mysql" {
	run await -r 1 mysql://unknown
	[ $status -eq 1 ]
}

@test "successful memcached connection" {
	run await -r 2 -i 0.5 memcached://memcached:11211
	[ $status -eq 0 ]
}

@test "unsuccessful memcached connection" {
	run await -r 2 memcached://unknown:11211
	[ $status -eq 1 ]
}

@test "successfull command with retry" {
	run await -r 2 cmd -- true
	[ $status -eq 0 ]
}

@test "unsuccessfull command with retry" {
	run await -r 2 cmd -- false
	[ $status -eq 1 ]
}

@test "cmd without a command" {
	run await -r 2 cmd
	[ $status -eq 1 ]
	echo "${output}" | grep -Fi 'usage'

	run await -r 2 cmd --
	[ $status -eq 1 ]
	echo "${output}" | grep -Fi 'usage'
}

@test "aws CLI is included in the image" {
	run aws --version
	[ $status -eq 0 ]
}
