(import (minimal-sqlite))

(define (disp . xs) (for-each display xs) (newline))

(let ((db (sql-open "test.db")))
  (sql-do db "create table if not exists config (name text, value text)")
  (disp (sql-do/row-id
         db "insert into config (name, value) values ('foo', 'bar')"))
  (for-each disp (sql-get-all db "select * from config"))
  (disp (sql-get-one
         db "select value from config where name = 'foo' limit 1"))
  (sql-close db))
