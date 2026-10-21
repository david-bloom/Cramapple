import { assertEquals } from "jsr:@std/assert@1";
import { clientIp } from "./request-metadata.ts";
Deno.test("client IP preserves CF precedence and first forwarded hop", () => {
  const req = (headers: HeadersInit = {}) => new Request("https://fixture", { headers });
  assertEquals(clientIp(req({ "cf-connecting-ip": " 1.2.3.4 ", "x-forwarded-for": "5.6.7.8, 9.0.1.2" })), "1.2.3.4");
  assertEquals(clientIp(req({ "cf-connecting-ip": " ", "x-forwarded-for": " 5.6.7.8, 9.0.1.2" })), "5.6.7.8");
  assertEquals(clientIp(req({ "x-forwarded-for": ", 9.0.1.2" })), null);
  assertEquals(clientIp(req()), null);
});
