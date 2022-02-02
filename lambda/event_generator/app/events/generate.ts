import { PutEventsCommand } from "@aws-sdk/client-eventbridge";
import { ebClient } from "./eb_client";

export function generate(): any {
  // Set the parameters.
  const params = {
    Entries: [
      {
        Detail: '{ "from": "lambda2", "to": "eventBridge" }',
        DetailType: "appRequestSubmitted",
        Resources: [
          "RESOURCE_ARN", //RESOURCE_ARN
        ],
        Source: "com.company.app",
      },
    ],
  };

  async () => {
    try {
      const data = await ebClient.send(new PutEventsCommand(params));
      console.log("Success, event sent; requestID:", data);
      return data; // For unit tests.
    } catch (err) {
      console.log("Error", err);
    }
  };
}