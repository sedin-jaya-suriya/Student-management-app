#!/bin/bash
set -e
bin/rails db:prepare
exec bin/rails server -b 0.0.0.0
