import { assertEquals, assertRejects } from "jsr:@std/assert@1";
import { checkedDatabase, RequiredDatabaseError } from "./checked-database.ts";

Deno.test("required database operations propagate data but hide provider error details", async () => {
  assertEquals(
    await checkedDatabase(Promise.resolve({ data: 3, error: null }), "write"),
    { data: 3, error: null },
  );
  const dbError = await assertRejects(
    () =>
      checkedDatabase(
        Promise.resolve({ error: { message: "private", code: "XX000" } }),
        "write",
      ),
    RequiredDatabaseError,
  );
  assertEquals([dbError.step, dbError.code, dbError.message], [
    "write",
    "XX000",
    "required_database_operation_failed",
  ]);
  const network = await assertRejects(
    () => checkedDatabase(Promise.reject(new Error("private")), "read"),
    RequiredDatabaseError,
  );
  assertEquals([network.step, network.code], ["read", "transport_error"]);
});
