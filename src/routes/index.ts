import type { FastifyInstance } from "fastify";
import { fintechRoutes } from "./fintechRoutes";

export async function router(app: FastifyInstance) {
  app.register(fintechRoutes, { prefix: "/fintech" });
}
