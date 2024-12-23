import aws_cdk.aws_lambda_event_sources as eventsources
from aws_cdk import (
    Duration,
    Stack,
    aws_lambda,
)
from aws_cdk import (
    aws_sns as sns,
)
from aws_cdk import (
    aws_sns_subscriptions as subs,
)
from aws_cdk import (
    aws_sqs as sqs,
)
from constructs import Construct


class CdkUvPythonExampleStack(Stack):
    def __init__(self, scope: Construct, construct_id: str, **kwargs) -> None:
        super().__init__(scope, construct_id, **kwargs)

        queue = sqs.Queue(
            self,
            "CdkUvPythonExampleQueue",
            visibility_timeout=Duration.seconds(300),
        )

        topic = sns.Topic(self, "CdkUvPythonExampleTopic")

        topic.add_subscription(subs.SqsSubscription(queue))

        # Lambda 関数
        function = aws_lambda.DockerImageFunction(
            scope=self,
            id=f"{self.stack_name}-lambda",
            function_name=f"{self.stack_name}-lambda",
            code=aws_lambda.DockerImageCode.from_image_asset(
                directory=".", cmd=["hello.handler"]
            ),
            timeout=Duration.seconds(9),
            environment={
                "QUEUE_URL": queue.queue_url,
            },
        )
        function.add_event_source(eventsources.SqsEventSource(queue))
