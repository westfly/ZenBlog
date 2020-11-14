#!/usr/bin/env bash
if [[ $# -gt 0 ]]; then
    hugo server  --buildDrafts --watch
else
    hugo server  --watch
fi
