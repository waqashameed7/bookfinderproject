#!/bin/bash
echo "Building application..."
mvn clean package -Pazure -DskipTests

echo "Getting deployment credentials..."
USERNAME=$(az webapp deployment list-publishing-profiles --resource-group bookfinder-resource-group --name book-finder-app-1759067134 --query "[?contains(publishMethod, 'FTP')].userName" -o tsv)
PASSWORD=$(az webapp deployment list-publishing-profiles --resource-group bookfinder-resource-group --name book-finder-app-1759067134 --query "[?contains(publishMethod, 'FTP')].userPWD" -o tsv)

echo "Uploading JAR file..."
curl -X PUT -u "$USERNAME:$PASSWORD" \
    "https://book-finder-app-1759067134.scm.azurewebsites.net/api/vfs/site/wwwroot/app.jar" \
    -H "Content-Type: application/octet-stream" \
    --data-binary @"target/book-finder-1.0-SNAPSHOT.jar"

echo "Setting startup command..."
az webapp config set \
    --resource-group bookfinder-resource-group \
    --name book-finder-app-1759067134 \
    --startup-file "java -jar /home/site/wwwroot/app.jar"

echo "Restarting app..."
az webapp restart --resource-group bookfinder-resource-group --name book-finder-app-1759067134

echo "✅ Deployment complete!"
echo "🌐 Check your app: https://book-finder-app-1759067134.azurewebsites.net"
