#!/bin/bash

# Define Colors
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

echo -e "${BOLD}--- AI Station: Service Endpoints ---${NC}"

# Get JSON data for all containers in this project
DATA=$(nerdctl compose ps --format json)

get_url() {
    local service_name=$1
    local path=$2
    local label=$3
    
    # Extract the published host port
    local port=$(echo "$DATA" | jq -r ".[] | select(.Service==\"$service_name\") | .Publishers[0].PublishedPort")
    
    if [ ! -z "$port" ] && [ "$port" != "null" ]; then
        printf "%-15s : ${BLUE}http://localhost:%s%s${NC}\n" "$label" "$port" "$path"
    fi
}

echo -e "${BOLD}Main Interfaces (UI)${NC}"
get_url "open-webui" "" "Open WebUI"
get_url "vlogs" "/select/vmui/" "VictoriaLogs"
get_url "phoenix" "" "Arize Phoenix"

echo -e "\n${BOLD}Backend / APIs${NC}"
get_url "ollama" "" "Ollama API"
get_url "vlogs" "/health" "Logs Health"

echo -e "\n${BOLD}--- Endpoints Listed ---${NC}"
