import { APIGatewayProxyEvent, APIGatewayProxyResult } from "aws-lambda";
import * as Sentry from "@sentry/serverless";
import { world } from "./hello/world";
// import { download } from "./s3/sample";

Sentry.init({
  dsn: process.env.SENTRY_DSN,
  environment: process.env.ENVIRONMENT_TYPE,
});
Sentry.setTag("env_name", process.env.ENVIRONMENT);

export const handler = Sentry.AWSLambda.wrapHandler(
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  async (event: APIGatewayProxyEvent): Promise<APIGatewayProxyResult> => {
    // const file = await download("my-file.txt");
    let result = world();
    console.log(result);
    return {
      statusCode: 200,
      body: `${result}`,
    };
  }
);
