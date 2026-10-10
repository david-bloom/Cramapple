-- Same-device capture (DECISION-0109): the phone leg reports how it reached
-- the capture page, and that report must win. claim_capture_pairing_upload
-- kept the FIRST value written (coalesce(access_path, p_access_path)), and
-- describe_capture had already stamped 'QR' by the time the upload claim
-- arrived, so every token read 'QR' whatever the path. The phone's declared
-- path now overrides a prior stamp; a null declaration keeps the stamp.
-- Body otherwise identical to 20260819120000_capture_pairing.sql.

create or replace function app.claim_capture_pairing_upload(
  p_handle_sha256 text,
  p_max_attempts integer,
  p_access_path text default null
)
returns app.capture_pairing_tokens
language plpgsql
security definer
set search_path = 'app', 'public'
as $$
declare
  v_row app.capture_pairing_tokens;
begin
  select * into v_row
  from app.capture_pairing_tokens
  where handle_sha256 = p_handle_sha256
  for update;

  if v_row.id is null then
    raise exception using errcode = 'P0001',
      message = 'capture_pairing:not_found';
  end if;

  -- Already-terminal capabilities: nothing to record, so raise directly.
  if v_row.state = 'consumed' then
    raise exception using errcode = 'P0001',
      message = 'capture_pairing:already_used';
  end if;
  if v_row.state = 'cancelled' then
    raise exception using errcode = 'P0001',
      message = 'capture_pairing:cancelled';
  end if;
  if v_row.state = 'rejected' then
    raise exception using errcode = 'P0001',
      message = 'capture_pairing:rejected';
  end if;
  if v_row.state = 'expired' then
    raise exception using errcode = 'P0001',
      message = 'capture_pairing:expired';
  end if;

  -- Just-now-terminal transitions COMMIT their bookkeeping by RETURNING the
  -- updated row rather than raising. A `RAISE` here would abort the function's
  -- own transaction and roll the UPDATE back -- the original defect, which
  -- made `state = 'rejected'` unreachable dead code and the "record the
  -- expiry" comment false. The caller distinguishes these from a live claim by
  -- inspecting the returned `state` (a live claim returns 'paired'/'uploaded').
  if v_row.expires_at <= now() then
    update app.capture_pairing_tokens
      set state = 'expired', closed_at = coalesce(closed_at, now())
      where id = v_row.id
      returning * into v_row;
    return v_row;
  end if;
  if v_row.redemption_attempts >= p_max_attempts then
    update app.capture_pairing_tokens
      set state = 'rejected', closed_at = coalesce(closed_at, now())
      where id = v_row.id
      returning * into v_row;
    return v_row;
  end if;

  update app.capture_pairing_tokens
    set redemption_attempts = redemption_attempts + 1,
        state = case when state = 'issued' then 'paired' else state end,
        paired_at = coalesce(paired_at, now()),
        access_path = coalesce(p_access_path, access_path)
    where id = v_row.id
    returning * into v_row;

  return v_row;
end;
$$;
