#!/bin/bash

# Book Finder Azure Deployment Script for Korea/Student Subscription
echo "Starting Azure deployment for Book Finder App..."

# Variables - Using different region and PostgreSQL Flexible Server
RESOURCE_GROUP="bookfinder-resource-group"
LOCATION="southeastasia"  # Changed from eastus to southeastasia (Singapore)
APP_NAME="book-finder-app-$(date +%s)"  # Unique name with timestamp
POSTGRES_SERVER="bookfinder-postgres-$(date +%s)"
POSTGRES_DB="bookfinder"
POSTGRES_USER="postgresadmin"
POSTGRES_PASSWORD="YourSecurePassword123!"

echo "Using resource group: $RESOURCE_GROUP"
echo "Using location: $LOCATION"
echo "Using app name: $APP_NAME"
echo "Using PostgreSQL server: $POSTGRES_SERVER"

# Create Resource Group
echo "Creating resource group..."
az group create --name $RESOURCE_GROUP --location $LOCATION

# Create PostgreSQL Flexible Server (newer version)
echo "Creating PostgreSQL Flexible Server..."
az postgres flexible-server create \
    --resource-group $RESOURCE_GROUP \
    --name $POSTGRES_SERVER \
    --location $LOCATION \
    --admin-user $POSTGRES_USER \
    --admin-password $POSTGRES_PASSWORD \
    --sku-name Standard_B1ms \
    --tier Burstable \
    --storage-size 32 \
    --version 13 \
    --yes

# Create Database
echo "Creating PostgreSQL database..."
az postgres flexible-server db create \
    --resource-group $RESOURCE_GROUP \
    --server-name $POSTGRES_SERVER \
    --database-name $POSTGRES_DB

# Configure PostgreSQL Firewall - Allow all Azure services
echo "Configuring PostgreSQL firewall..."
az postgres flexible-server firewall-rule create \
    --resource-group $RESOURCE_GROUP \
    --name $POSTGRES_SERVER \
    --rule-name allowAllAzureIPs \
    --start-ip-address 0.0.0.0 \
    --end-ip-address 0.0.0.0

# Create App Service Plan
echo "Creating App Service plan..."
az appservice plan create \
    --name bookfinder-app-service-plan \
    --resource-group $RESOURCE_GROUP \
    --sku B1 \
    --is-linux

# Create Web App
echo "Creating Web App..."
az webapp create \
    --resource-group $RESOURCE_GROUP \
    --plan bookfinder-app-service-plan \
    --name $APP_NAME \
    --runtime "JAVA:8-jre8"

# Get PostgreSQL connection details
POSTGRES_URL="jdbc:postgresql://${POSTGRES_SERVER}.postgres.database.azure.com:5432/${POSTGRES_DB}?sslmode=require"

echo "PostgreSQL URL: $POSTGRES_URL"

# Configure environment variables
echo "Configuring application settings..."
az webapp config appsettings set \
    --resource-group $RESOURCE_GROUP \
    --name $APP_NAME \
    --settings \
        SPRING_PROFILES_ACTIVE=azure \
        POSTGRES_URL="$POSTGRES_URL" \
        POSTGRES_USERNAME="$POSTGRES_USER" \
        POSTGRES_PASSWORD="$POSTGRES_PASSWORD"

echo "==========================================="
echo "Azure resources created successfully!"
echo "Web App URL: https://${APP_NAME}.azurewebsites.net"
echo "PostgreSQL Server: ${POSTGRES_SERVER}.postgres.database.azure.com"
echo "==========================================="
echo "Next steps:"
echo "1. Run: mvn clean package -Pazure"
echo "2. Run: mvn azure-webapp:deploy -Dazure.webapp.name=${APP_NAME}"
echo "==========================================="