# Variables
LOCAL_NODE=${LOCAL_NODE:-local}
REMOTE_NODE=${REMOTE_NODE:-remote}
REMOTE_NODE_SSH=${REMOTE_NODE_SSH:-ssh://root@1.2.3.4}
LOCAL_ARCH=${LOCAL_ARCH:-linux/arm64,linux/riscv64,linux/ppc64le,linux/s390x,linux/mips64le,linux/mips64,linux/arm/v7,linux/arm/v6}
REMOTE_ARCH=${REMOTE_ARCH:-linux/amd64,linux/386}
DRIVER_OPT=${DRIVER_OPT:-'--driver-opt env.BUILDKIT_STEP_LOG_MAX_SIZE=10000000 --driver-opt env.BUILDKIT_STEP_LOG_MAX_SPEED=10000000'}

# Parse command line options and build accordingly
while [[ $# -gt 0 ]]; do
   case $1 in
   -l | --local)
      docker buildx build --builder "$(docker buildx create --driver-opt env.BUILDKIT_STEP_LOG_MAX_SIZE=10000000 --driver-opt env.BUILDKIT_STEP_LOG_MAX_SPEED=10000000)" -t spurin/${PWD##*/}:$(git branch | grep '*' | awk {'print $2'}) . --load
      exit
      ;;
   -c | --crossbuild)
      docker buildx create --name build_flappydock --driver-opt env.BUILDKIT_STEP_LOG_MAX_SIZE=10000000 --driver-opt env.BUILDKIT_STEP_LOG_MAX_SPEED=10000000
      docker buildx use build_flappydock
      docker buildx build --platform linux/amd64,linux/arm64/v8 -t spurin/${PWD##*/}:$(git branch | grep '*' | awk {'print $2'}) . --push
      exit
      ;;
   -cr | --crossbuildremote)
      # Remove the build instance
      docker buildx rm build_flappydock-remote

      # Create the build instance and add the local builder
      docker buildx create --name build_flappydock-remote --node $LOCAL_NODE --platform $LOCAL_ARCH $DRIVER_OPT

      # Create the remote builder
      docker buildx create --name build_flappydock-remote --append --node $REMOTE_NODE $REMOTE_NODE_SSH --platform $REMOTE_ARCH $DRIVER_OPT

      # Use the builder and bootstrap
      docker buildx use build_flappydock-remote
      docker buildx inspect --bootstrap

      # Crossbuild and push to Docker Hub
      docker buildx build --platform linux/amd64,linux/arm64/v8 -t spurin/${PWD##*/}:$(git branch | grep '*' | awk {'print $2'}) . --push
      exit
      ;;
   *)
      echo "Unknown option $1, options are -l --local, -c --crossbuild, -cr --crossbuildremote"
      exit 1
      ;;
   esac
done
exit
