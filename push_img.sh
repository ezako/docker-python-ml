tag=$1

docker build . -t base_img
img_id=$(docker images -q base_img)

docker tag $img_id ezako1/docker-python-ml:$tag
docker push ezako1/docker-python-ml:$tag

docker tag $img_id ezako1/docker-python-ml:latest
docker push ezako1/docker-python-ml:latest