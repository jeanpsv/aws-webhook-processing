resource "aws_sqs_queue" "webhook-requests" {
  name = "webhook-requests-queue"
}