import type { FastifyInstance } from "fastify";
import { z } from "zod";
import type { ZodTypeProvider } from "fastify-type-provider-zod";
import { db } from "@repo/database";

export async function fintechRoutes(app: FastifyInstance) {
  const typedApp = app.withTypeProvider<ZodTypeProvider>();

  typedApp.get(
    "/balance",
    {
      schema: {
        response: {
          200: z.object({
            success: z.boolean(),
            balance: z.number(),
            currency: z.string(),
          }),
        },
      },
    },
    async (request, reply) => {
      // Verify database client can compile and import correctly
      request.log.info(`[fintechRoutes] DB client check: ${!!db}`);

      return {
        success: true,
        balance: 1500.00,
        currency: "USD",
      };
    }
  );
}
