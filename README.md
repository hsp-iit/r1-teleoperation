# Build the docker

```jsx
# BUILDARE DOCKER FILE
export DOCKER_BUILDKIT=1
export GITHUB_TOKEN=YOURGITHUBTOKEN
docker build --secret id=github_token,env=GITHUB_TOKEN -t ergocub-custom:latest .

# LANCIARE CONTAINER
stat -c '%n %g %G' /dev/dri/card* /dev/dri/renderD*
/dev/dri/card1 44 video
/dev/dri/card2 44 video
/dev/dri/renderD128 992 render
/dev/dri/renderD129 992 render

docker run -it --privileged --network host --device=/dev/dri:/dev/dri
--group-add 44 --group-add 992 --pid host -e NVIDIA_DRIVER_CAPABILITIES=all
-e __NV_PRIME_RENDER_OFFLOAD=1  -e __GLX_VENDOR_LIBRARY_NAME=nvidia
-e __VK_LAYER_NV_optimus=NVIDIA_only -e DISPLAY -e ROS_DOMAIN_ID=${ROS_DOMAIN_ID}
-v CYCLONEDDS_URI:/home/user1/.config/cyclone_dds_settings.xml -v /tmp/.X11-unix:/tmp/.X11-unix
-e QT_X11_NO_MITSHM=1 --gpus all ergocub-custom:latest
```
