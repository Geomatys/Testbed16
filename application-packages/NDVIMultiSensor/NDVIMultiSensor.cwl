{
    "cwlVersion": "v1.0",
    "class": "CommandLineTool",
    "requirements": {
        "DockerRequirement": {
            "dockerPull": "testbed16-nb-test-multi:latest"
        }
    },
    "arguments": ["/home/guilhem/run.sh", "/home/guilhem/testbed16.ipynb","/home/guilhem/out.ipynb"],
    "inputs": {
        "files": {
            "inputBinding": {
                "position": 1,
            },
            "type": {
                "type": "array",
                "items": "File"
            }
        },
    },
    "outputs": {
        "output": {
            "outputBinding": {
                "glob": "*.tif"
            },
            "type": {
                "type": "array",
                "items": "File"
            }
        }
    }
}