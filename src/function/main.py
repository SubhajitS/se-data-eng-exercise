import functions_framework

from loader import *

@functions_framework.cloud_event
def load_file(cloud_event):
    data = cloud_event.data
    print(data)
    content_type=data["contentType"]
    if content_type == "text/csv":
        bucket = data["bucket"]
        name = data["name"]
        uri = f"gs://{bucket}/{name}"
        print(uri)

        load_from_uri(uri)
    else:
        print("Invalid file format")