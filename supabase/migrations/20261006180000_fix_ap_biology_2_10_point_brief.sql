-- APPROVAL-0127 (David, 2026-10-06): fix the AP Biology 2.10 topic point brief.
-- The brief told students they earn points for circular DNA, ribosomes and binary fission as
-- endosymbiosis evidence. The CED's required content for 2.10 (EK 2.10.A.1-3, Fall 2025 CED p. 62)
-- states only the endosymbiotic origin and the prokaryote/eukaryote compartmentalization contrast;
-- circular chromosomes appear only in 6.1. Double membranes stay: they are 2.1 content (CED Topic 2.1).
update app.topic_point_briefs
set how_points_are_earned = 'You earn points by explaining that mitochondria and chloroplasts evolved from once free-living prokaryotic cells by endosymbiosis, supporting it with evidence such as their double membranes, and contrasting how prokaryotic and eukaryotic cells compartmentalize.',
    answer_move = 'State the endosymbiotic origin, then compare: prokaryotes have specialized internal regions without membrane-bound organelles, while eukaryotes partition the cell with internal membranes.',
    common_point_loss = 'Naming mitochondria and chloroplasts without saying they came from free-living prokaryotes, or claiming prokaryotes have no internal organization at all.',
    updated_at = now()
where subject_key = 'ap_biology' and topic_code = '2.10';
