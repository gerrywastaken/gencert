#!/bin/bash
tag="v${1}"
git tag $tag
git push origin
git push origin $tag
