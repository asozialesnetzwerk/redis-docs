#!/bin/sh

set -xeu

: "${REPOSITORY_URL:=https://github.com/asozialesnetzwerk/redis-docs}"

# Prepares the Netlify preview
: "${REDIS_STACK_REPOSITORY:="github.com/redis-stack/redis-stack-website"}"
if [ -n "${PRIVATE_ACCESS_TOKEN:-}" ]; then
    REDIS_STACK_REPOSITORY="$PRIVATE_ACCESS_TOKEN@$REDIS_STACK_REPOSITORY"
fi
repo_dir=$(pwd)

rm -rf website
git clone --recurse-submodules "https://$REDIS_STACK_REPOSITORY" website
cd website

# TODO: fix jedis
# sed -i 's/"dev_branch": "emb-examples",/"dev_branch": "6.x",/g' data/stack/jedis.json
printf '%s' 'diff --git a/data/stack/index.json b/data/stack/index.json
index 8037409..b86ebb3 100644
--- a/data/stack/index.json
+++ b/data/stack/index.json
@@ -13,8 +13,7 @@
         "nredisstack",
         "go_redis",
         "node_redis",
-        "redis_py",
-        "jedis"
+        "redis_py"
     ],
     "modules": [
         "redisearch",
' | git apply

# TODO: fix modules
printf '%s' 'diff --git a/data/stack/index.json b/data/stack/index.json
index b86ebb3..e20e168 100644
--- a/data/stack/index.json
+++ b/data/stack/index.json
@@ -16,11 +16,6 @@
         "redis_py"
     ],
     "modules": [
-        "redisearch",
-        "redisjson",
-        "redistimeseries",
-        "redisbloom",
-        "redisgears"
     ],
     "assets": [],
     "_assets": [
' | git apply -

REPO_DIR=$repo_dir REPOSITORY_URL=$REPOSITORY_URL PREVIEW_MODE=1 make deps build
