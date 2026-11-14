select subject_key, count(*) published, count(quick_take) with_quick_take, count(*) filter (where quick_take is not null and char_length(quick_take)<=400) within_cap
from app.topic_explainers where status='published' and unit_number between 1 and 5 and subject_key in ('ap_chemistry','ap_biology','ap_statistics') group by 1 order by 1;
select count(*) other_rows_with_quick_take from app.topic_explainers where quick_take is not null and not (unit_number between 1 and 5 and subject_key in ('ap_chemistry','ap_biology','ap_statistics'));
select count(*) published_total from app.topic_explainers where status='published';
