#!/bin/bash

bloggo && cp resources/root/* public/ && git add . && git commit -m "bump" && git push
