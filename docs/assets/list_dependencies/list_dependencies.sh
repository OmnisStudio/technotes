#!/bin/bash

# Usage message
usage() {
    echo "Usage: $0 <path_to_so_or_executable_or_directory>"
    exit 1
}

# Check for argument
if [ $# -eq 0 ]; then
    usage
fi

# Check if the provided argument is a file or directory
if [ ! -d "$1" ] && [ ! -f "$1" ]; then
    echo "The argument must be a file or directory"
    exit 1
fi

# Define a function to check if the path is a system dependency
is_system_dependency() {
    if [[ $1 == *"/workspace/linux-output/build"* ]]; then
        echo "No"
    else
        echo "Yes"
    fi
}

declare -A all_deps

# Function to process dependencies of a file
process_file() {
    local file=$1
    
    while IFS= read -r line; do
        
        dep=$(echo "$line" | awk '{print $1}')
        path=$(echo "$line" | awk '{print $(NF-1)}')

        # Skip empty lines and linux-vdso
        if [[ -n "$dep" ]] && [[ "$dep" != "linux-vdso.so"* ]]; then
            
            system_dep=$(is_system_dependency "$path")
            
            key="$dep|$system_dep"
            all_deps["$key"]=1
        fi
    done < <(ldd "$file" 2>/dev/null | grep "=>")
}

# Check if the argument is a file or directory
if [ -f "$1" ]; then
    process_file "$1"
elif [ -d "$1" ]; then
    for so_file in "$1"/*; do
        if [ -f "$so_file" ] && [[ "$so_file" == *.so || "$so_file" == * ]]; then
            process_file "$so_file"
        fi
    done
fi

# Generate the markdown table
echo "| Dependency | System |"
echo "|------------|--------|"
for key in "${!all_deps[@]}"; do
    IFS='|' read -ra ADDR <<< "$key"
    echo "| ${ADDR[0]} | ${ADDR[1]} |"
done

exit 0
