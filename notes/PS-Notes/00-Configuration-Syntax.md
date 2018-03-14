# Configuration Syntax- Terraform Manifests

- Single line comments start with #

- Multi-line comments are wrapped with /* and */

- Values are assigned with the syntax of key = value (whitespace doesn't matter). The value can be any primitive (string, number, boolean), a list, or a map.

- Strings are in double-quotes.

- Strings can interpolate other values using syntax wrapped in ${}, such as ${var.foo}. The full syntax for interpolation is documented here.

- Multiline strings can use shell-style "here doc" syntax, with the string starting with a marker like <<EOF and then the string ending with EOF on a line of its own. The lines of the string and the end marker must not be indented.

- Numbers are assumed to be base 10. If you prefix a number with 0x, it is treated as a hexadecimal number.

- Boolean values: true, false.

- Lists of primitive types can be made with square brackets ([]). Example: ["foo", "bar", "baz"].

- Maps can be made with braces ({}) and colons (:): { "foo": "bar", "bar": "baz" }. Quotes may be omitted on keys, unless the key starts with a number, in which case quotes are required. Commas are required between key/value pairs for single line maps. A newline between key/value pairs is sufficient in multi-line maps.