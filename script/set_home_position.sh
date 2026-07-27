#!/bin/bash
echo "positionMoveGroupRPC (0 1 2 3 4 5 6 7 8 9 10 11 12) (-50.0 19.0 14.0 70.0 0.01 0.03 0.0 60.0 0.0 0.0 0.0 0.0 0.0)" | yarp write ... /cer/right_arm/nws/rpc:i
echo "positionMoveGroupRPC (0 1 2 3 4 5 6 7 8 9 10 11 12) (-50.0 19.0 14.0 70.0 0.01 0.03 0.0 60.0 0.0 0.0 0.0 0.0 0.0)" | yarp write ... /cer/left_arm/nws/rpc:i
echo "positionMoveGroupRPC (0 3) (0.012 0.0)" | yarp write ... /cer/torso/nws/rpc:i
echo "positionMoveGroupRPC (0 1) (0.0 0.0)" | yarp write ... /cer/head/nws/rpc:i
