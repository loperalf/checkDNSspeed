#!/bin/bash

# Mapping of DNS server IP addresses to names
# Do you can Add a DNS server in this line to define the name
declare -A DNS_SERVER_NAMES
DNS_SERVER_NAMES["8.8.8.8"]="Google"
DNS_SERVER_NAMES["8.8.4.4"]="Google"
DNS_SERVER_NAMES["208.67.222.222"]="OpenDNS"
DNS_SERVER_NAMES["208.67.220.220"]="OpenDNS"
DNS_SERVER_NAMES["1.1.1.1"]="Cloudflare"
DNS_SERVER_NAMES["1.0.0.1"]="Cloudflare"
DNS_SERVER_NAMES["9.9.9.9"]="Quad9"
DNS_SERVER_NAMES["149.112.112.112"]="Quad9"
DNS_SERVER_NAMES["64.6.64.6"]="Verisign"
DNS_SERVER_NAMES["64.6.65.6"]="Verisign"
DNS_SERVER_NAMES["190.248.0.4"]="Tigo"
DNS_SERVER_NAMES["200.31.208.101"]="Tigo"

# List of DNS servers to test
# Add the sanme Dir IP to make a test
DNS_SERVERS=(
    "8.8.8.8"   # Google Public DNS
    "8.8.4.4"   # Google Public DNS
    "208.67.222.222"   # OpenDNS
    "208.67.220.220"   # OpenDNS
    "1.1.1.1"   # Cloudflare
    "1.0.0.1"   # Cloudflare
    "9.9.9.9"   # Quad9
    "149.112.112.112"   # Quad9
    "64.6.64.6" # Verisign
    "64.6.65.6" # Verisign
    "190.248.0.4" # Tigo
    "200.31.208.101" # Tigo
)

# Function to test the response time of a DNS server
# The script check for a simple web site, if you need to check a internal site and internal DNS, change the URL
function test_dns_server {
    local dns_server=$1
    local name=${DNS_SERVER_NAMES[$dns_server]}
    local time=$(dig +noall +stats +time=1 google.com @$dns_server 2>&1 | awk '/^;; Query/ { print $4 }')
    printf "%-10s %s (%s) %s\n" "$time" "$(tput setaf 2)$name$(tput sgr0)" "$(tput setaf 3)$dns_server$(tput sgr0)" "$(tput setaf 6)🚀$(tput sgr0)"
}

# Print header
echo "$(tput setaf 6)🔎  Testing DNS servers...$(tput sgr0)"

# Loop through the DNS servers and test their response time
for dns_server in "${DNS_SERVERS[@]}"
do
    test_dns_server "$dns_server"
done | sort -n -k1 | awk '{printf "Fastest DNS server: %s (%s) with response time: %s ms\n", $(NF-2), $(NF-1), $1; exit}'