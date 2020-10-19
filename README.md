# SRFI nnn: Minimal SQLite interface

by Firstname Lastname, Another Person, Third Person

# Status

Early Draft

# Abstract

# Issues

# Rationale

# Specification

(**sql-open** _database-name_ . _parameters_) => _database_

(**sql-close** _database_)

(**sql-do** _database_ _statement_)

Execute one SQL _statement_ for its side effects. [TODO: parameters and escaping]

Raise an exception unless the statement is successful.

While **sql-do** can execute any SQL statement, it's meant for things
like `INSERT`, `UPDATE`, and `DELETE` where the side effect is
important but the return value (if any) is not.

(**sql-do/row-id** _database_ _statement_) => _integer_

Like **sql-do** but returns the row ID that was affected by
_statement_. For example, an `INSERT` statement would return the ID of
the new row. Raise an exception if the row ID is not available.

Row IDs in SQL are an implementation-defined feature which is somewhat
brittle in practice. Hence the use of row IDs is an anti-pattern. For
the sake of convenience we provide them anyway. Use with caution.

(**Implementation note**: Each SQLite connection keeps a global row ID
value. We set it to 0 before executing the statement. If it stays
zero, we raise an exception. Else we return the new row ID. While
SQLite does not have an official value to denote an invalid row ID,
zero is a de facto standard because SQLite row IDs start counting up
from 1 unless you manually set the counter to less than 1. Note that
SQLite row IDs can be negative, though only if the row ID counter is
manually set to a negative value.)

(**sql-get-all** _database_ _statement_ [_map-row_ _row-accumulator_])
=> _state_

Execute one SQL _statement_ like **sql-do** but also fetch any and all
resulting rows.

For each row, call `(apply map-row columns)`. In other words,
_map-row_ gets as many arguments as there are result columns. The
arguments use Scheme datatypes: integer, real, string. SQL blobs
become Scheme bytevectors.

SQL `NULL` becomes Scheme `null` for compatibility with
[SRFI 180](http://srfi.schemers.org/srfi-180/srfi-180.html)
and with other SQL databases that have more types.
Notably, `#t` and `#f` would be the natural values
of a boolean column, making `#f` unusable as `NULL`.

Each call to _map-row_ should return one value
and the _row-accumulator_ is called with that value.
Finally, _row-accumulator_ is tail-called with an
end-of-file object.
Whatever _row-accumulator_ returns
(possibly multiple values) becomes the
return value from **sql-get-all**.

If _map-row_ is not supplied, the default is `vector`, which turns each
result row into a Scheme vector.

If _row-accumulator_ is not supplied, the default is
`list-accumulator` from SRFI 158, which collects the rows into a list.

(**sql-get-one** _database_ _statement_ [_map-row_]) => _values_

Like **sql-get-all** but expects exactly one result row. If there are
no rows, or if there is more than row, an exception is raised.

Return the values from tail-calling `(apply map-row columns)` with the
sole result row, the result. The details are as for **sql-get-all**.
However, if _map-row_ returns multiple values, all of them are
preserved.

If _map-row_ is not supplied, the default is `values` which returns
the columns of the row as multiple values. `values` is a good default
because a query returning a single SQL value returns a single Scheme
value. The Scheme programmer will not have to unpack that value from a
one-element vector or list.

# Implementation

Gambit FFI implementation attached.

# Acknowledgements

This API was inspired by the [Bigloo SQLite
module](https://www-sop.inria.fr/mimosa/fp/Bigloo/manual-chapter17.html).

# References

# Copyright

Copyright (C) Firstname Lastname (20XY).

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
