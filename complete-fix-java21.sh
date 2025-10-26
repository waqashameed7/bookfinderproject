#!/bin/bash
echo "=== Complete Fix for Java 21 ==="

# 1. Set Java 21 runtime (matches your updated pom.xml)
echo "1. Setting Java 21 runtime..."
az webapp config set \
    --resource-group bookfinder-resource-group \
    --name book-finder-app-1759067134 \
    --linux-fx-version "JAVA|21-java21"

# 2. Build the application with Java 21 profile
echo "2. Building application for Java 21..."
mvn clean package -Pazure -DskipTests

if [ ! -f "target/book-finder-1.0-SNAPSHOT.jar" ]; then
    echo "❌ Build failed - JAR file not found"
    exit 1
fi

echo "✅ Build successful - JAR size: $(du -h target/book-finder-1.0-SNAPSHOT.jar | cut -f1)"

# 3. Deploy using Zip Deploy (most reliable)
echo "3. Creating deployment package..."
mkdir -p temp-deploy
cp target/book-finder-1.0-SNAPSHOT.jar temp-deploy/
cd temp-deploy
zip -r ../deployment.zip . > /dev/null
cd ..

echo "4. Deploying to Azure..."
az webapp deployment source config-zip \
    --resource-group bookfinder-resource-group \
    --name book-finder-app-1759067134 \
    --src deployment.zip

# Cleanup
rm -rf temp-deploy deployment.zip

# 5. Set startup command
echo "5. Setting startup command..."
az webapp config set \
    --resource-group bookfinder-resource-group \
    --name book-finder-app-1759067134 \
    --startup-file "java -jar /home/site/wwwroot/book-finder-1.0-SNAPSHOT.jar"

# 6. Enable detailed logging
echo "6. Enabling detailed logging..."
az webapp log config \
    --resource-group bookfinder-resource-group \
    --name book-finder-app-1759067134 \
    --application-logging filesystem \
    --detailed-error-messages true \
    --failed-request-tracing true \
    --level verbose

# 7. Restart the application
echo "7. Restarting application..."
az webapp restart --resource-group bookfinder-resource-group --name book-finder-app-1759067134

echo "8. Waiting for application to start..."
sleep 30

# 9. Check final status
echo "9. Final status check..."
az webapp show \
    --resource-group bookfinder-resource-group \
    --name book-finder-app-1759067134 \
    --query "{state: state, status: status, javaVersion: siteConfig.linuxFxVersion}"

echo "✅ Complete fix applied!"
echo "🌐 Check your app: https://book-finder-app-1759067134.azurewebsites.net"
echo ""
echo "📋 To check logs, run:"
echo "az webapp log tail --resource-group bookfinder-resource-group --name book-finder-app-1759067134"
