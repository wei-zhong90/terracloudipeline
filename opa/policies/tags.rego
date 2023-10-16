package terraform.tags

deny[msg] {
	match(changes[c].change.after)
	msg := sprintf("fail: %v is missing required tags.", [changes[c].address])
}

match (i) {
	not i.tags
}

match(i) {
	not i.tags.foo
}

match(i) {
	not i.tags.bar
}

changes := { c |
	some path, value
	walk(input, [path, value])
	reverse_index(path, 1) == "resource_changes"
	c = value[_]
}

reverse_index(path, idx) = value {
	value := path[count(path) - idx]
}