[
  {
    "name": "${app_name}-app",
    "image": "${app_image}",
    "networkMode": "awsvpc",
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/${app_name}-app",
          "awslogs-region": "${aws_region}",
          "awslogs-stream-prefix": "ecs"
        }
    },
    "environment": [
      {
        "name": "env",
        "value": "%ENV%"
      },
      {
        "name": "AWS_DEFAULT_REGION",
        "value": "${aws_region}"
      }
    ]
  }
]
