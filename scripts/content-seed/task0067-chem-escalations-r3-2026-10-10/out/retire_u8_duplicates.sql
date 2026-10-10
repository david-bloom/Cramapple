-- DECISION-0113: retire two Unit 8 content duplicates; their content remains inside the fuller entries
-- "Acid ionization constant, Ka" (8.3, includes pKa = -log Ka) and "Water autoionization constant, Kw" (8.1, includes pKw = pH + pOH).
begin;
update app.topic_memory_hooks set status = 'retired'
 where reference_entry_id in (select reference_entry_id from app.unit_reference_entries
   where subject_key = 'ap_chemistry' and kind = 'formula' and ((owner_topic_code = '8.3' and title = 'pKa') or (owner_topic_code = '8.1' and title = 'pKw, pH and pOH at 25°C')));
update app.unit_reference_entries set status = 'retired', source_note = source_note || '; retired=DECISION-0113 duplicate'
 where subject_key = 'ap_chemistry' and kind = 'formula' and status = 'published'
   and ((owner_topic_code = '8.3' and title = 'pKa') or (owner_topic_code = '8.1' and title = 'pKw, pH and pOH at 25°C'));
commit;
