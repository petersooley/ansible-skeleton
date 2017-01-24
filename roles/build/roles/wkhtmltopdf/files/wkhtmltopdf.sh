#!/usr/bin/env bash

exec xvfb-run -a --server-args="-screen 0, 1024x768x24" /usr/bin/wkhtmltopdf "$@"
