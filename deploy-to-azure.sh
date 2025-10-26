#!binbash

# Variables
RESOURCE_GROUP=bookfinder-resource-group
LOCATION=eastus
APP_NAME=book-finder-app
POSTGRES_SERVER=bookfinder-postgres-server
POSTGRES_DB=bookfinder
POSTGRES_USER=postgresadmin
POSTGRES_PASSWORD=YourSecurePassword123!

# Create Resource Group
echo Creating resource group...
az group create --name $RESOURCE_GROUP --location $LOCATION

# Create PostgreSQL Server
echo Creating PostgreSQL server...
az postgres server create 
    --resource-group $RESOURCE_GROUP 
    --name $POSTGRES_SERVER 
    --location $LOCATION 
    --admin-user $POSTGRES_USER 
    --admin-password $POSTGRES_PASSWORD 
    --sku-name B_Gen5_1 
    --version 11

# Create PostgreSQL Database
echo Creating PostgreSQL database...
az postgres db create 
    --resource-group $RESOURCE_GROUP 
    --server-name $POSTGRES_SERVER 
    --name $POSTGRES_DB

# Configure PostgreSQL Firewall
echo Configuring PostgreSQL firewall...
az postgres server firewall-rule create 
    --resource-group $RESOURCE_GROUP 
    --server-name $POSTGRES_SERVER 
    --name allowAllAzureIPs 
    --start-ip-address 0.0.0.0 
    --end-ip-address 0.0.0.0

# Create App Service Plan
echo Creating App Service plan...
az appservice plan create 
    --name bookfinder-app-service-plan 
    --resource-group $RESOURCE_GROUP 
    --sku B1 
    --is-linux

# Create Web App
echo Creating Web App...
az webapp create 
    --resource-group $RESOURCE_GROUP 
    --plan bookfinder-app-service-plan 
    --name $APP_NAME 
    --runtime JAVA8-jre8

# Get PostgreSQL connection details
POSTGRES_URL=jdbcpostgresql${POSTGRES_SERVER}.postgres.database.azure.com5432${POSTGRES_DB}sslmode=require

# Configure environment variables
echo Configuring application settings...
az webapp config appsettings set 
    --resource-group $RESOURCE_GROUP 
    --name $APP_NAME 
    --settings 
        SPRING_PROFILES_ACTIVE=azure 
        POSTGRES_URL=$POSTGRES_URL 
        POSTGRES_USERNAME=${POSTGRES_USER}@${POSTGRES_SERVER} 
        POSTGRES_PASSWORD=$POSTGRES_PASSWORD

echo Azure resources created successfully!
echo Web App URL https${APP_NAME}.azurewebsites.net