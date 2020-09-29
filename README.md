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
the sake of convenience We provide them anyway. Use with caution.

(**Implementation note**: Each SQLite connection keeps a global row ID
value. We set it to 0 before executing the statement. If it stays
zero, we raise an exception. Else we return the new row ID. While
SQLite does not have an official value to denote an invalid row ID,
zero is a de facto standard because SQLite row IDs start counting up
from 1 unless you manually set the counter to less than 1.]

expects exactly one row back and does (apply mapfun
row). The mapfun may return multiple values, which are returned
from sql-query-one. It raises an exception if it gets no rows, or if
it gets more than one row.

(**sql-get-all** _database_ _statement_ [_mapfun_ _accumulator_]) => _state_

Execute one SQL _statement_ like **sql-do** but also fetch any and all
resulting rows.

For each row, call `(apply mapfun columns)`. In other words, _mapfun_
gets as many arguments as there are result columns. The arguments use
Scheme datatypes: integer, real, string. SQL blobs become Scheme
bytevectors. SQL null becomes Scheme `#f`.

Each _mapfun_ should return one value. _accumulator_ is called with
that value. In the end, _accumulator_ is tail-called with an
end-of-file object. Then it should return its state, which becomes the
return value from **sql-get-all**. If _accumulator_ returns multiple
values, all of them are preserved.

If _mapfun_ is not supplied, the default is `vector` which turns each
result row into a Scheme vector.

If _accumulator_ is not supplied, the default is `list-accumulator`
from SRFI 158. It collects the rows into a list.

(**sql-get-one** _database_ _statement_ [_mapfun_]) => _values_

Like **sql-get-all** but expects exactly one result row. If there are
no rows, or if there is more than row, an exception is raised.

`(apply mapfun columns)` is tail-called with the sole result row and
returns the result. The details are as for **sql-get-all**. However,
if _mapfun_ returns multiple values, **sql-get-one** preserves them
all.

If _mapfun_ is not supplied, the default is `values` which returns the
columns of the row as multiple values.

# Implementation

Gambit FFI implementation attached.

# Acknowledgements

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
