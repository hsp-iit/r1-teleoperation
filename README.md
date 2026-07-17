# R1 TELEOPERATION

This repo contains dockerfile, launch file and script needed to teleoperate R1.

## Repo structure
- *applications*: contains three yarpmanager applications, one for the real robot, and two for the simulation;
- *dockerfile*: contains the dockerfile to be build to have the simulation running on your laptop;
- *gz*: contains the worlds of gazebo;
- *launch*: contains lauch files to start and stop things in REAL robot in an easy way;
- *script*: contains script to restore the starting position of the teleoperation (both for real and simulated robot).

### Build the docker

```jsx
# BUILD DOCKER FILE
cat > .env <<EOF
VIDEO_GID=$(getent group video | cut -d: -f3)
RENDER_GID=$(getent group render | cut -d: -f3)
ROS_DOMAIN_ID=0
CYCLONEDDS_FILE=YOURPATHTOCYCLONE


export GITHUB_TOKEN=YOURGITHUBTOKEN
cd dockerfile
docker compose build

docker compose run --rm simulation bash
```
