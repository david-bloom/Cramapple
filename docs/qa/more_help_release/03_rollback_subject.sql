-- PRODUCTION: switch ONE subject off immediately (the reservation function then refuses it with
-- subject_not_supported before any model call). Never delete the ap-calculus-ab/bc or ap-chemistry rows
-- unless the owner has asked to turn those off. Substitute __SUBJECT__.
begin;
delete from app.more_help_subject_policy where subject_key = '__SUBJECT__'
  and subject_key not in ('ap-calculus-ab','ap-calculus-bc','ap-chemistry');
select * from app.more_help_subject_policy order by subject_key;
commit;
