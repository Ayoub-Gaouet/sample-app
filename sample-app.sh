#!/bin/bash

# Install Docker
sudo apt-get update
sudo apt-get install -y docker.io

# Ensure Jenkins user has Docker permissions
sudo usermod -aG docker jenkins

# Exit from the script if any command fails
set -e

# Your existing script
mkdir tempdir
mkdir tempdir/templates
mkdir tempdir/static

cp sample_app.py tempdir/.
cp -r templates/* tempdir/templates/.
cp -r static/* tempdir/static/.

echo "FROM python" >> tempdir/Dockerfile
echo "RUN pip install flask" >> tempdir/Dockerfile
echo "COPY  ./static /home/myapp/static/" >> tempdir/Dockerfile
echo "COPY  ./templates /home/myapp/templates/" >> tempdir/Dockerfile
echo "COPY  sample_app.py /home/myapp/" >> tempdir/Dockerfile
echo "EXPOSE 5050" >> tempdir/Dockerfile
echo "CMD python /home/myapp/sample_app.py" >> tempdir/Dockerfile

# Build and run Docker
cd tempdir
/usr/bin/docker build -t sampleapp .
/usr/bin/docker run -t -d -p 5050:5050 --name samplerunning sampleapp
/usr/bin/docker ps -a
