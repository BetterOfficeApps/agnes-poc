resource "aws_sqs_queue" "event_queue" {
  name = "agnes-test-queue"
  message_retention_seconds = 7200

  tags = {
    Environment = "development"
  }
}
