import { EventBridgeClient } from "@aws-sdk/client-eventbridge";

const REGION = process.env.AWS_REGION;
export const ebClient = new EventBridgeClient({ region: REGION });
