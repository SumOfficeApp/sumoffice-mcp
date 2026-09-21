#!/bin/sh
# Remote (nothing to install):
claude mcp add --transport http sumoffice https://view.sumoffice.com/mcp
# Local over stdio, files from the current folder are visible to the agent as /work/<name>:
# claude mcp add sumoffice -- docker run -i --rm -v "$PWD:/work" hissih/sumoffice-mcp
