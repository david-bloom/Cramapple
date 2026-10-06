-- TASK-0064 re-enable condition 2 (APPROVAL-0124). Two client screens in the published app still read
-- published MCQs straight from content_item_versions with no teaching-item filter:
-- /session with selectedFormat 'mcq' (buildPublishedMcqQuery) and /session/mcq (usePublishedMcqs).
-- Hide active Open Hand teaching items from the student read policy so that no client-side read can
-- serve one. Open Hand reads teaching items through the security-definer RPC
-- get_open_hand_teaching_item, and edge functions use the service role, so neither is affected.
-- Admin and assigned-reviewer policies are unchanged.

-- RLS evaluates the predicate as the caller. The function is security definer and returns only a boolean.
grant execute on function app.content_item_is_teaching(uuid) to authenticated;

alter policy content_item_versions_select_published on app.content_item_versions
  using ((status = 'published'::text)
         and app.content_item_is_published(content_item_id)
         and not app.content_item_is_teaching(content_item_id));
