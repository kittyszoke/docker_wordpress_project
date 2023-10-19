# Wordpress

This repo contains every file and details you'll need to sucessfully run your WordPress blog. We have already created the blog's title `Fernando's Blog`, but feel free to change the it and other details to your preference. 

**WordPress site:**
`http://wordpress.askj.academy.labs.automationlogic.com/`

**Files Included in this repo:**
- Dockerfile 
- docker-compose file 
- Kubernetes manifests 
- Scripts for running test and deployment
- WordPress configuration file


### **Pre-requisits:**

To successfully run the scripts you'll need:

- BitBucket - to clone repo: `git clone https://kittyszoke@bitbucket.org/kittyszoke/wordpress.git`#no longer available
- Access to Jenkins (details will be provided)
- Files to build app
- RDS to connect to

The technologies and platforms used are:

- AWS 
- Docker
- Rancher and Kubernetes
- Terraform
- Jenkins
- BitBucket

## How to build your WordPress page?

1. Make sure your inftastraucture is up to date. If not, you can just simply log in to Jenkins, click on `Build Cluster` and on the left click on `Build now`. This will build/update your infrastructure to run all your apps.

2. On Jenkins, Make sure you are on the `Dashboard` then click on `WordpressTest` and on the left click `Build now`. This will automatically start the testing and will trigger the deployment to build your Wordpress blog. 
   - If you would like to skip the testing part and just simply deply, on the `Dashboard` select `WordpressDeploy` and `Build now`

**Plase Note:** Jenkins will atuomatically test and deploy every time the developers push new code to BitBucket the **master branch**

__________________________________________________________________________________________________________________________

## Run testing and deployment

As previously stated, jenkins will take care of your testing and deployment phase.

We made sure that everything runs as smoothly as possible, but in case anything would happen, you can find some helpful details here:

### Jenkins Python error message

We have bumpoed into a very particular problem while creating the testing side of the script. 
If Jenkins brings up error messages regarding python socket connection, please make sure that the **Jenkins Agent** set-up as below:

```bash 

cd /etc/systemd/system/sockets.target.wants

sudo nano docker.socket

```

Change the line SocketMode=0660 to **SocketMode=0666**

Then run:

```bash

sudo systemctl daemon-reload
sudo systemctl restart docker.socket

```

___________________________________________________________________________________________________________________________

## How to access the DB

We have already created an RDS database, that saves all your data of all your application. As always, we will provide you with the log in details during our handover.

In case you wish to add other databases or acces the existing one you can do the following


### Install MySQL on pod

To install the database client on your pods, gi into the `k8s` folder and run the following command:

- `kubectl exec -it <pod_name> -n <namespace>` 
   - the namespace on our manifest is `askjwordpress` and the pod names can be found by running the `kubectl get pods -n <namespace>` command

- After accesgin the pod, update and install the database client:

``` bash

apt update
apt -y install mariadb-client

```

- Now you can log into the database:

``` bash

mysql -h <rds_endpoint> -u<username> -p<password>

```

After successfully logging into your db, you can see and work with the wordpress database, which includes all the information you might need.

If you have a brand new cluster, you can manually create your database. To do that, make sure you log into the db through one of the pods (as described above) and do the following commands:

```bash

create database wordpress;

```

**Make sure the database name is wordpress, otherwise you might have problems connecting to your database**


_____________________________________________________________________________________________________________________


## WordPress Configuration file

To run WordPress successfully, we also had to make adjustments to the `wp-config.php` file. If you would like to change anything regarding the database in the future, make sure you change the following lines in the file:


```bash

# The name of the database for WordPress 
define( 'DB_NAME', getenv_docker('WORDPRESS_DB_NAME', '<DB NAME>') ); 

# Database username 
define( 'DB_USER', getenv_docker('WORDPRESS_DB_USER', '<DB USERNAME>') );

# Database password 
define( 'DB_PASSWORD', getenv_docker('WORDPRESS_DB_PASSWORD', '<DB PASSWORD>') );

# Database hostname 
define( 'DB_HOST', getenv_docker('WORDPRESS_DB_HOST', '<RDS ENDPOINT>') );

```

**All the above infromation has to match in all dockerfile and docker-compose file, as well as K8s manifests**

_________________________________________________________________________________________________________________

## Manual Set-ups

In case anything would happen on any stage, you will everything you need to know about the manual creation of your wordpress site here.


### Dockerfile

We used the Docker file to create your image. This will use a wordpress imaghe and update the config file on your wordpress to match the database settings.

**Please make sure you use a dedicated VM, as the code does not cover specifications, such as Mac with M chips.**

To create an image run the following commands in the `wordpress_files` directory:

```bash

docker build -t <name_for_image> .

# Test to see if it works - please make sure port 80 is available
docker run -d -p 80:80 --name <name_of_container> <name_of_image>

# Tag your image
docker tag <name_of_iamge> <private_ip_of_registry>:5000/<name_of_image>

# Push it to private registery
docker push <private_ip_of_registry>:5000/<name_of_image>

# Restart
sudo systemctl restart docker

```

### Build with docker-compose

make sure you are in the `wordpress_files` directory, then run:

```bash

docker-compose up -d

# Check if it's up and running
docker-compose ps

```

Other helpful commands:

```bash

# Check logs of docker compose
docker-compose logs <name>

# To remove docker compose file
docker-compose rm -sf 

# remove all images docker-compose and -v if you would like to the volumes too
docker-compose down --rmi all -v
```

### Kubernetes Manifests

The yaml files can be found in the `k8s` directory. you can run the following commands - **Make sure they are in the same order as stated below, starting with namespace**

```bash

kubectl apply -f namespace.yml
kubectl apply -f dbsvc.yml
kubectl apply -f deployment.yml
kubectl apply -f service.yml
kubectl apply -f ingress.yml

```

Other helpful commands:

```bash

# To see detailed description of the deployment
kubectl describe deploy -n <namespace> | less

# To delete manifests
kubectl delete -f <filename>.yml

# Get the running containers
kubectl get pods -n <namespace>

# See the details for specific pods - Allows me to see which node is used
kubectl describe pods <pod_name> -n <namespace>

# To log into a node
kubectl exec -it <node_name> -n <namespace> -- bash

# Check - Did it deploy? -n flag has to be followed by the name of the "namespace"
kubectl get deploy -n <namespace>

# delete pod
kubectl delete pod <pod_name> -n <namespace>

```