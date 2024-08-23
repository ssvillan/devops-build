## APPLICATION ##
•	Clone the below mentioned repo and deploy the application. (Run the application in port 80 [HTTP]) Repo URL: https://github.com/ssvillan/devops-build.git

	Create Instance  > Connect to the Capstone project Instance 
	Before install any in Ubuntu you have to do Update first [sudo apt update ] Install the Nginx server [sudo apt-get install nginx –y]
	Next  cd  /etc/nginx/ ->> ls –a  ->>  cd sites-available/  ->> Inside the directory  write vi mysite ->>
server {
 listen 80;
 server_name 15.207.109.116; (ip address)

 root /var/www/mysite;
index index.html;

 location / {
  try_files $uri $uri/ =404;
    }
}
Save this file
	Next  use this command for ( This file to another file )   sudo ln –s  /etc/nginx/sites-available/mysite /etc/nginx/sites-enabled/   ->>
After use that command you have use nginx –t ->> Configure the file test is successful message come.

	Go to cd/var/www/ ->> Inside this directory create directory  mkdir mysite ->>
	 clone your repo in Ubuntu git clone https://github.com/ssvillan/devops-build.git
	cd devops-build/ ->> cd build/ -> copy all the application file  use this command 
cp –r * /var/www/mysite/ ->> than it will go all the files inside the /var/www/mysite/ directory 
	Affter that you have to go to /var/www/mysite directory and check what ever you copy files is there or  not inside your directory .
	After that you have open the port 80 in AWS Secuity Group . 
	You want to see your  running application
	And use this IP address 15.207.109.116:80 




## DOCKER ##
•	Dockerize the application by creating a Dockerfile
•	Create a docker-compose file to use the above image
	First clone your repo    git clone https://github.com/ssvillan/devops-build.git
	Install Docker and Dsetup 
	Next cd devops-build/ ->> cd build/ ->> use vi editore for
	 vi Dockerfile ->> Inside this file write code 

FROM nginx
WORKDIR /usr/share/nginx/html
COPY . /usr/share/nginx/html
EXPOSE 80

Docker build –t  mynginximg . ->>
Successfully build image mynginximg (image id 88e1295c5b23)

	Install Docker-compose and setup
	Next create vi docker-compose.yaml ->> file  use vi editore and inside this yaml file write code.

version: '3'
services:
  web:
    image: mynginximg:latest
    ports:
      - "3000:80"

Next,   docker-compose up –d ->>
Successfully build container       build_web_1 
	Next  open the port 3000 in AWS Security Group 
	And You want to see your  running application
 use this IP address 15.207.109.116:3000





## BASH SCRIPITING (Write 2 scripts) ##
•	build.sh-for building docker images
•	deploy.sh for deploying the image to server

	Clone the repo in Ubuntu 
	Git clone https://github.com/ssvillan/devops-build.git
	cd devops-build/ ->> cd build/ ->>
	next vi build.sh ->>  write the code inside this file

#!/bin/bash

# Variables
IMAGE_NAME="buildnginximg"
TAG="latest"

# Step 1: Build the Docker image
echo "Building Docker image: buildnginximg:latest"
docker build -t buildnginximg:latest .

# Step 2: Optionally tag the image with another tag
# Uncomment the line below if you want to tag the image with another version
# docker tag $IMAGE_NAME:$TAG $IMAGE_NAME:your-tag

# Step 3: Optional cleanup
# Uncomment the line below to remove the local image after
pushing
# docker rmi $nginximg:latest
echo "Docker image build"
	next chmod +x build.sh ->> ./build.sh ->> after that successfully build image name buildnginximg 
	Afftet that create vi deploy.sh ->> inside this file write code-

#!/bin/bash

# Variables
IMAGE_NAME="buildnginximg"
TAG="latest"
CONTAINER_NAME="buildnginx_container"
PORT="80"  # Adjust the port as necessary

# Step 1: Pull the latest image from Docker Hub
echo "Pulling the latest Docker image: nginximg:latest"
docker pull "buildnginximg:latest"

# Step 2: Stop the currently running container (if any)
echo "Stopping the currently running container: $CONTAINER_NAME"
docker stop $CONTAINER_NAME || true
docker rm $CONTAINER_NAME || true

# Step 3: Run a new container with the latest image
echo "Running a new container: buildnginx_container"
docker run -d --name buildnginx_container -p 5000:80 buildnginximg:latest


	Next chmod +x deploy.sh ->> ./deploy.sh ->> after that successfully build docker container name buildnginx_container (id - 88020a8e3972)  and deployment complete.
	Next  open the port 3000 in AWS Security Group 
	And You want to see your  running application
 use this IP address 15.207.109.116:5000






## VERSION CONTROL ##
• Push the code to github to dev branch (use .dockerignore & gitignore files)
Note: Use only CLI for related git commands

	In Ubuntu clone repo  git clone https://github.com/ssvillan/devops-build.git
	Create .gitignore file  vi .gitignore ->> inside this file write the code 
# Node.js specific
node_modules/
npm-debug.log
yarn-debug.log
yarn-error.log

# Logs
logs/
*.log
# Environment files
.env

# Optional npm cache directory
.npm

# Operating system files
.DS_Store
Thumbs.db

# IDEs
.vscode/
.idea/

# Build files
/dist/
/build/

	Create .dockerignore file vi .dockerignore ->> inside this file write the code 
# Ignore node_modules directory
node_modules

# Ignore logs
logs
*.log

# Ignore environment files
.env

# Ignore Git files
.git
.gitignore

# Ignore Dockerfile itself (optional)
Dockerfile

# Ignore IDE files
.vscode/
.idea/

# Ignore build directories
/dist/
/build/

	Create the vi Jenkinsfile ->> inside this file write the code 
pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                // Grant executable permissions to the build script
                sh 'chmod +x build.sh'

                // Build the Docker image using the build script
                sh './build.sh'
            }
        }

        stage('Deploy') {
            steps {
                // Grant executable permissions to the deploy script
                sh 'chmod +x deploy.sh'

                // Deploy the Docker image using the deploy script
                sh './deploy.sh'
            }
        }
    }
}

	Create the Prometheus file vi Prometheus.yaml ->> inside the file write code 

global:
  scrape_interval: 15s  # How often to scrape targets
  evaluation_interval: 15s  # How often to evaluate rules

scrape_configs:
  # Scrape Prometheus itself
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  # Scrape Node Exporter
  - job_name: 'node-exporter'
    static_configs:
      - targets: ['<NODE_EXPORTER_IP>:9100']

	All these files push to github dev branch  in one time
	Use git init ->> git add .  ->> git checkout  –b  dev ->>
	Git push –u origin dev  ->> and Enter your username and passwd
	Successfully push the all code inside the dev branch 




## DOCKER HUB ##
• Create 2 repos "dev" and "prod" to push images. "Prod" repo must be private and "dev" repo can be public

	Click the link https://hub.docker.com/search?image_filter=official&q=
And got to inside the page and sign in the page 
After sign in got to repositories and create the repo
Write the repo name prod and choose the private and click create button 
Again create the repo name dev and choose the public and click create button
	Inside your Ubuntu git clone https://github.com/ssvillan/devops-build.git
	Next Docker Login ->> docker tag mynginximg sumitdhal/dev ->> 
docker tag buildnginximg sumitdhal/dev->>
Next docker push sumitdhal/dev ->>

	Docker tag mynginximg sumitdhal/prod ->> 
Docker tag buildnginximg sumitdhal/prod  ->>
docker push sumitdhal/prod ->>

	after that you can go dockerhub web page and check your repositories succressfully push all the code






## JENKINS  ##
	Install and configure jenkins build step as per needs to build, push & deploy the

	Inside the Ubuntu first I need to install openjdk-17     [sudo apt install openjdk-17-jdk ]
	After that I need to open the port 8080 in AWS Security group  
Copy the IP address and serch in google with port 8080
	Next open Unlock jenkin file  use code in Ubuntu  
sudo cat  /var/lib/Jenkins/secrets/initialAdminpassword 
after open this file one passwd is there and copy the passwd . got to the Unlock Jenkin page Administrator password  is there  paste the passwd  and clicke the continue button.
Next Install button is there after Installation  Create First Admin User fill up and save and continue 
Next  instance Configure  save and Finish
Next jenkin is ready page is there  go and  start using Jenkins…..

	Jenkinsfile create and write down to the code in vi Jenkinsfile ->> Inside

pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                // Grant executable permissions to the build script
                sh 'chmod +x build.sh'

                // Build the Docker image using the build script
                sh './build.sh'
            }
        }

        stage('Deploy') {
            steps {
                // Grant executable permissions to the deploy script
                sh 'chmod +x deploy.sh'

                // Deploy the Docker image using the deploy script
                sh './deploy.sh'
            }
        }
    }
}




	Next open manage Jenkins->system configuration- >system->environment variables->
Add Here add your environment variables for docker i.e docker username and password 

	 Next in same manage Jenkins->security->credentials- >global 
 Add docker login credentials then only docker image can be built and pushed . 

	 now create new item-> give a title for it->
Click pipeline Then your item is created

	This is already build but just for reference I’ve showed you here

	Connect Jenkins to Github:
Configure GitHub webhook to trigger builds on push events. • Go to GitHub repository settings -> Webhooks -> Add webhook -> Jenkins URL

	Go to your Jenkins item [ Capstone project ] and click build now.
	Check the console output whether docker image gets created and pushed  
	Also I got some error so I did update commit .
	 Then you can check in Jenkins build gets triggered automatically 





## AWS ##
•	Launch t2.micro instance and deploy the create application.
•	Configure SG as below:
•	Whoever has the ip address can access the application
•	Login to server can should be made only from your ip address

	Create Instance  > Connect to the Capstone project Instance 
	Before install any in Ubuntu you have to do Update first [sudo apt update ] Install the Nginx server [sudo apt-get install nginx –y]
	Next  cd  /etc/nginx/ -> ls –a  ->  cd sites-available/  -> Inside the directory  write vi mysite -> 
server {
 listen 80;
 server_name 15.207.109.116; (ip address)

 root /var/www/mysite;
index index.html;

 location / {
  try_files $uri $uri/ =404;
    }
}
Save this file
	Next  use this command for ( This file to another file )   sudo ln –s  /etc/nginx/sites-available/mysite /etc/nginx/sites-enabled/   ->
After use that command you have use nginx –t -> Configure the file test is successful message come.

	Go to cd/var/www/ -> Inside this directory create directory  mkdir mysite -> 
	 clone your repo in Ubuntu git clone https://github.com/ssvillan/devops-build.git
	cd devops-build/ -> cd build/ -> copy all the application file  use this command 
cp –r * /var/www/mysite/ -> than it will go all the files inside the /var/www/mysite/ directory 
	Affter that you have to go to /var/www/mysite directory and check what ever you copy files is there or  not inside your directory .
	After that you have open the port 80 in AWS Secuity Group . 
	You want to see your  running application
	And use this IP address 15.207.109.116:80 

	These are the port I have enable and take  Screenshot   





## MONITORING ##
• Setup a monitoring system to check the health status of the application. (Open-source)
• Sending notifications only if the application goes down is highly appreciable


	Here I open two port 9090 and port 9100
	Port 9090 for  Prometheus and Port 9100 for Node Exporter
	Prometheus after Install it :
 And after configuration I can check the health status of the application and sending notification only if the application goes down is highly appreciable





|| CODE RELATED ALL FILES ARE THERE IN DEV BARANCH ||
