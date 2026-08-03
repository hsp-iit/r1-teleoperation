#!/usr/bin/env bash
set -e

BASE_HOST="r1-base"
TORSO_HOST="r1-torso"
FACE_HOST="r1-face"

ECC_CONTAINER="vibrant_borg"
CONSOLE_CONTAINER="hopeful_albattani"

echo "=== Avvio infrastruttura YARP ==="

echo
echo "[1] yarpserver su base"
ssh "${BASE_HOST}" '
  echo "Sono su host: $(hostname)"
  echo "User: $(whoami)"
  tmux kill-session -t yarpserver 2>/dev/null || true
  tmux new-session -d -s yarpserver "yarpserver --write > /tmp/yarpserver.log 2>&1"
  sleep 4
  echo "--- log yarpserver ---"
  tail -n 30 /tmp/yarpserver.log || true
'

echo
echo "[2] yarprun /r1-base su base"
ssh "${BASE_HOST}" '
  echo "Sono su host: $(hostname)"
  echo "User: $(whoami)"
  tmux kill-session -t yarprun_base 2>/dev/null || true
  tmux new-session -d -s yarprun_base "yarprun --server /r1-base --log > /tmp/yarprun_base.log 2>&1"
  sleep 4
  echo "--- log yarprun_base ---"
  tail -n 30 /tmp/yarprun_base.log || true
  echo "--- check /r1-base ---"
  yarp name list | grep /r1-base || true
'

echo
echo "[3] yarprun /r1-torso su torso"
ssh "${TORSO_HOST}" '
  bash -ilc "
    echo Sono su host: \$(hostname)
    echo User: \$(whoami)
    echo PATH: \$PATH
    echo yarp: \$(which yarp 2>/dev/null || echo NON_TROVATO)
    echo yarprun: \$(which yarprun 2>/dev/null || echo NON_TROVATO)

    tmux kill-session -t yarprun_torso 2>/dev/null || true
    tmux new-session -d -s yarprun_torso \"yarprun --server /r1-torso --log > /tmp/yarprun_torso.log 2>&1\"
    sleep 4

    echo --- log yarprun_torso ---
    tail -n 50 /tmp/yarprun_torso.log || true
  "
'
echo
echo "[3] yarprun /r1-face su face"
ssh "${FACE_HOST}" '
  bash -ilc "
    echo Sono su host: \$(hostname)
    echo User: \$(whoami)
    echo PATH: \$PATH
    echo yarp: \$(which yarp 2>/dev/null || echo NON_TROVATO)
    echo yarprun: \$(which yarprun 2>/dev/null || echo NON_TROVATO)

    tmux kill-session -t yarprun_face 2>/dev/null || true
    tmux new-session -d -s yarprun_face \"yarprun --server /r1-face --log > /tmp/yarprun_face.log 2>&1\"
    sleep 4

    echo --- log yarprun_face ---
    tail -n 50 /tmp/yarprun_face.log || true
  "
'

echo
echo "[check da base] /r1-torso"
ssh "${BASE_HOST}" '
  yarp name list | grep /r1-torso || echo "Manca /r1-torso"
'

echo
echo "[check da base] /r1-face"
ssh "${BASE_HOST}" '
  yarp name list | grep /r1-face || echo "Manca /r1-face"
'

echo
echo "[4] yarprun /ecc-base dentro vibrant_borg"
ssh "${BASE_HOST}" "
  echo 'Sono su host base:' \$(hostname)
  docker start ${ECC_CONTAINER} >/dev/null
  sleep 2

  docker exec ${ECC_CONTAINER} bash -ilc '
    echo \"Sono dentro container: \$(hostname)\"
    echo \"User container: \$(whoami)\"
    echo \"PATH: \$PATH\"
    echo \"yarp: \$(which yarp 2>/dev/null || echo NON_TROVATO)\"
    echo \"yarprun: \$(which yarprun 2>/dev/null || echo NON_TROVATO)\"

    tmux kill-session -t yrun 2>/dev/null || true
    tmux new-session -d -s yrun \"yarprun --server /ecc-base --log > /tmp/yarprun_ecc_base.log 2>&1\"
    sleep 4

    echo \"--- log yarprun_ecc_base ---\"
    tail -n 50 /tmp/yarprun_ecc_base.log || true

    echo \"--- tmux ls nel container ---\"
    tmux ls || true
  '
"

echo
echo "[check da base] /ecc-base"
ssh "${BASE_HOST}" '
  yarp name list | grep /ecc-base || echo "Manca /ecc-base"
'

echo
echo "[5] yarprun /console dentro hopeful_albattani"
ssh "${BASE_HOST}" "
  echo 'Sono su host base:' \$(hostname)
  docker start ${CONSOLE_CONTAINER} >/dev/null
  sleep 2

  docker exec ${CONSOLE_CONTAINER} bash -lc '
    echo \"Sono dentro container: \$(hostname)\"
    echo \"User container: \$(whoami)\"
    tmux kill-session -t yrun 2>/dev/null || true
    tmux new-session -d -s yrun \"yarprun --server /console --log > /tmp/yarprun_console.log 2>&1\"
    sleep 4
    echo \"--- log yarprun_console ---\"
    tail -n 50 /tmp/yarprun_console.log || true
    echo \"--- tmux ls nel container ---\"
    tmux ls || true
  '
"

echo
echo "[check finale]"
ssh "${BASE_HOST}" '
  yarp name list
'
