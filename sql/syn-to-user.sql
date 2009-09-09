--
--
-- syn-to-user
--    create local synonyms OWNER.object for user.synonym
--
-- Usage:
--    sqlplus dba/pass@bd @ syn-to-user.sql OWNER user
--
--    Marcus Vinicius Ferreira                  ferreira.mv[ at ] gmail.com
--    2009-06
--

SET PAGESIZE 0
SET LINESIZE 200
SET FEEDBACK OFF
SET VERIFY OFF
SET ECHO OFF

DEFINE _owner=&&1
DEFINE  _user=&&2

-- owner exists?
WHENEVER SQLERROR EXIT
    SELECT 'User: '||username FROM all_users WHERE username = upper('&&_owner') ;
    SELECT 'User: '||username FROM all_users WHERE username = upper('&&_user')  ;
/

WHENEVER SQLERROR CONTINUE

SELECT 'create or replace synonym '||RPAD( '&&_user..'||object_name,50,' ')||' for &&_owner..'||RPAD(object_name,31,' ')
     ||'-- '||object_type||' ;'
  FROM all_objects
 WHERE owner = upper('&&_owner')
 ORDER BY object_type,1
/

SELECT CHR(10)||'-- removing invalids'||chr(10)||'--' from dual;

SELECT 'drop synonym '||synonym_name||'; -- '||RPAD(obj.object_type,31,' ')||obj.owner||'.'||obj.object_name
  FROM user_synonyms syn
     , all_objects   obj
 WHERE syn.table_owner = obj.owner (+)
   AND syn.table_name  = obj.object_name (+)
   AND obj.object_name IS NULL
 ORDER BY syn.synonym_name
        , obj.object_type
        , obj.object_name
     ;

SET FEEDBACK ON

