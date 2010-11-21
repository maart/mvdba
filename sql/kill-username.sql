--
-- Kill sessions by username
--
-- 2010/11

set time off
set timing off
set feedback off
set pagesize 0
set echo off

spool /tmp/1.sql

select 'alter system kill session '
       ||CHR(39)||sid||','||serial#||CHR(39)||';'
  from v$session
 where username = UPPER('&1')
/

spool off

set echo on
@/tmp/1.sql
