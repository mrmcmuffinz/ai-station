#!/bin/bash

# Define Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

echo -e "${BOLD}--- AI Station: 2026 Health Check ---${NC}"

# Get JSON data for all containers in this project
DATA=$(nerdctl compose ps --format json)

check_external_service() {
    local service_name=$1
    local health_path=$2
    
    # Extract the published host port
    local port=$(echo "$DATA" | jq -r ".[] | select(.Service==\"$service_name\") | .Publishers[0].PublishedPort")
    
    if [ -z "$port" ] || [ "$port" == "null" ]; then
        echo -e "${RED}✘ $service_name:${NC} No port mapped to host."
        return
    fi

    local url="http://localhost:$port$health_path"
    
    # Perform the heartbeat
    local status=$(curl -s -o /dev/null -w "%{http_code}" --max-time 2 "$url")

    if [ "$status" == "200" ]; then
        echo -e "  ${GREEN}✔ $service_name${NC} (Port $port) - Status: $status"
    else
        echo -e "  ${RED}✘ $service_name${NC} (Port $port) - Status: $status (Check failed)"
    fi
}

check_internal_service() {
    local service_name=$1
    
    # Check if the container is running and has a healthy process
    if nerdctl ps --filter "name=$service_name" --filter "status=running" | grep -q "$service_name"; then
        # For Fluent Bit, we check if it's actually processing by looking for the binary in the process list
        if nerdctl exec "$service_name" pgrep fluent-bit > /dev/null 2>&1; then
             echo -e "  ${GREEN}✔ $service_name${NC} (Internal) - Process Active"
        else
             echo -e "  ${RED}✘ $service_name${NC} (Internal) - Process Not Found"
        fi
    else
        echo -e "  ${RED}✘ $service_name${NC} - Container not running"
    fi
}

echo -e "${BLUE}${BOLD}[ Infrastructure Layer ]${NC}"
check_external_service "vlogs" "/health"
check_internal_service "fluent-bit"

echo -e "\n${BLUE}${BOLD}[ Tracing Layer ]${NC}"
check_external_service "phoenix" "/"

echo -e "\n${BLUE}${BOLD}[ AI Application Layer ]${NC}"
check_external_service "ollama" "/api/tags"
check_external_service "open-webui" "/health"

echo -e "\n${BOLD}--- GPU Status ---${NC}"
if command -v nvidia-smi &> /dev/null; then
    nvidia-smi --query-gpu=utilization.gpu,temperature.gpu,memory.used --format=csv,noheader,nounits | \
    awk -F', ' '{print "  GPU Load: "$1"% | Temp: "$2"°C | VRAM Used: "$3"MB"}'
else
    echo -e "  ${RED}NVIDIA-SMI not found${NC}"
fi

echo -e "\n${BOLD}--- Check Complete ---${NC}"
