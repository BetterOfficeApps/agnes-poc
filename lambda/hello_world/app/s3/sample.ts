import { GetObjectCommand, S3Client } from "@aws-sdk/client-s3";
import { Readable } from "stream";

export async function download(
  object_key: string
): Promise<Readable | ReadableStream | Blob> {
  const s3Client = new S3Client({
    endpoint: process.env.S3_ENDPOINT,
    forcePathStyle: true,
  });
  const params = {
    Bucket: process.env.S3_BUCKET,
    Key: object_key,
  };
  const data = await s3Client.send(new GetObjectCommand(params));
  return data.Body;
}
