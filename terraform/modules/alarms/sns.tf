resource "aws_sns_topic" "cloudwatch_alarm_topic" {
  name = "cloudwatch-alarm-topic"
}

resource "aws_sns_topic_subscription" "cloudwatch_alarm_email_subscriber" {
  topic_arn = aws_sns_topic.cloudwatch_alarm_topic.arn
  protocol  = "email"
  endpoint  = "edmerc8@gmail.com"
}
