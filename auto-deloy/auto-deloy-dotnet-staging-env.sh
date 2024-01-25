#!/bin/bash

PORT=6001
DOTNET_PUBLISH_PID=$(lsof -t -i :$PORT)
isChanged=$(cd ~/workspaces/SoKHCNVTAPI && git pull)

logFileName="SoKHCNVTAPI.$(date +'%m-%d-%Y')"
mkdir -p /tmp/Staging

echo "------------" | tee -a "/tmp/Staging/${logFileName}.log"
date | tee -a "/tmp/Staging/${logFileName}.log"
echo "Port: $PORT" | tee -a "/tmp/Staging/${logFileName}.log"
echo "ProcessID: $DOTNET_PUBLISH_PID" | tee -a "/tmp/Staging/${logFileName}.log"
echo "IsChanged: $isChanged" | tee -a "/tmp/Staging/${logFileName}.log"

if [[ "${isChanged}" != "Already up to date." ]]; then
    echo "Repo has changed" | tee -a "/tmp/Staging/${logFileName}.log"
    if [[ -n "${DOTNET_PUBLISH_PID}" ]]; then
        echo "Port ${PORT} is used by ${DOTNET_PUBLISH_PID}" | tee -a "/tmp/Staging/${logFileName}.log"
        kill -9 "${DOTNET_PUBLISH_PID}"
    fi

    echo "Rebuild App" | tee -a "/tmp/Staging/${logFileName}.log"
    cd ~/workspaces/SoKHCNVTAPI/SoKHCNVTAPI && dotnet run --urls=http://localhost:6001/
else
    echo "Repo has no changes!" | tee -a "/tmp/Staging/${logFileName}.log"

    if [[ -z "${DOTNET_PUBLISH_PID}" ]]; then
        echo "Restart App" | tee -a "/tmp/Staging/${logFileName}.log"
        cd ~/workspaces/SoKHCNVTAPI/SoKHCNVTAPI && dotnet run --urls=http://localhost:6001/
    fi
fi