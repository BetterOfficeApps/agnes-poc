import { APIGatewayProxyEvent, APIGatewayProxyResult } from "aws-lambda";
import * as Sentry from "@sentry/serverless";
import { generate } from "./events/generate";

Sentry.init({
  dsn: process.env.SENTRY_DSN,
  environment: process.env.ENVIRONMENT_TYPE,
});
Sentry.setTag("env_name", process.env.ENVIRONMENT);

export const handler = Sentry.AWSLambda.wrapHandler(
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  async (event: APIGatewayProxyEvent): Promise<APIGatewayProxyResult> => {
    const result = generate();
    console.log(result);
    return {
      statusCode: 200,
      body: `${result}`,
    };
  }
);
