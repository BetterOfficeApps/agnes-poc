import { PutEventsCommand } from "@aws-sdk/client-eventbridge";
import { ebClient } from "./eb_client";

const params = {
  Entries: [
    {
      Detail: '{ "from": "lambda2", "to": "eventBridge" }',
      DetailType: "appRequestSubmitted",
      Source: "com.company.app",
    },
  ],
};

export const generate = async () => {
  try {
    const data = await ebClient.send(new PutEventsCommand(params));
    console.log("Success, event sent; requestID:", data);
    return data; // For unit tests.
  } catch (err) {
    console.log("Error", err);
    return "error";
  }
};
