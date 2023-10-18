import json
from github import Github, Auth
import hcl
import os

token = os.getenv['token']
repo = os.getenv['repo']

auth = Auth.Token(token)

g = Github(auth=auth)

repo = g.get_repo(repo)
contents = repo.get_contents("example.auto.tfvars", ref="main")

def trigger(event, context):
    body = {
        "message": "Go Serverless v3.0! Your function executed successfully!",
        "input": event,
    }

    response = {"statusCode": 200, "body": json.dumps(body)}

    return response

def parse_event(event, sample_item):
    for k in event['snow_variables']:
        if k == "req_id":
            sample_item[k] = event[k]
        elif k == "additional_tags":
            for sk in event[k]:
                sample_item['additional_tags'][sk] = event[k][sk]


