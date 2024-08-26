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
        table_id = "ee-india-se-data.movies_data_subhajit."
        if name.startswith("movies"):
            table_id += "movies_raw"
        elif name.startswith("ratings"):
            table_id += "ratings_raw"
        load_from_uri(uri, table_id)
    else:
        print("Invalid file format")