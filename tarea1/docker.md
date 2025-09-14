brew install --cask docker       
export PATH="/Applications/Docker.app/Contents/Resources/bin/:$PATH"

docker login -u mirandani94
curl https://auth.docker.io/token
docker login -u mirandani94

docker pull datasciencetoolbox/dsatcl2e:latest

