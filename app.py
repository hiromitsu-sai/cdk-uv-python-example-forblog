#!/usr/bin/env python3

import aws_cdk as cdk

from cdk_uv_python_example.cdk_uv_python_example_stack import CdkUvPythonExampleStack


app = cdk.App()
CdkUvPythonExampleStack(app, "CdkUvPythonExampleStack")

app.synth()
