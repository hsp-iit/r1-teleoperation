#!/usr/bin/env bash
set -e

BASE_HOST="r1-base"
TORSO_HOST="r1-torso"
FACE_HOST="r1-face"

ECC_CONTAINER="vibrant_borg"
CONSOLE_CONTAINER="busy_chebyshev"

echo "=== Stop infrastruttura YARP behaviour cloning ==="

ssh "${BASE_HOST}" '
  tmux kill-session -t yarprun_base 2>/dev/null || true
  tmux kill-session -t yarpserver 2>/dev/null || true
'

ssh "${TORSO_HOST}" '
  tmux kill-session -t yarprun_torso 2>/dev/null || true
'

ssh "${FACE_HOST}" '
  tmux kill-session -t yarprun_face 2>/dev/null || true
'

ssh "${BASE_HOST}" "
  docker exec ${ECC_CONTAINER} bash -lc 'tmux kill-session -t yrun 2>/dev/null || true' || true
  docker exec ${CONSOLE_CONTAINER} bash -lc 'tmux kill-session -t yrun 2>/dev/null || true' || true
"

echo "=== Tutto fermato ==="
