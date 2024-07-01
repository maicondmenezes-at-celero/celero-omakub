# Directory containing optional app scripts
OPTIONAL_DIR="$HOME/.local/share/omakub/install/optional"

# Initialize arrays for different types of apps
apps=()
descriptions=()

# Function to add apps and descriptions to the respective arrays
add_app() {
    local app_name="$1"
    local app_desc="$2"
    apps+=("$app_name")
    descriptions+=("$app_name: $app_desc")
}

# Function to extract the title from a script
get_title() {
    local script="$1"
    local title=$(grep -m 1 "^# Title:" "$script" | sed "s/^# Title: //")
    echo "$title"
}

# Function to extract the description from a script
get_description() {
    local script="$1"
    local description=""
    while IFS= read -r line; do
        if [[ "$line" =~ ^#\ Description: ]]; then
            description+="${line#"# Description: "}\n"
        fi
    done < "$script"
    echo -e "$description"
}

# Function to process the script name
process_script_name() {
    local script_name="$1"
    if [[ "$script_name" == app-* ]]; then
        app_name="${script_name#app-}"
        echo "${app_name^}"
    elif [[ "$script_name" == apps-* ]]; then
        app_name="${script_name#apps-}"
        echo "Apps For ${app_name^}"
    else
        echo "${script_name^}"
    fi
}

# Loop through the scripts in the optional directory
for script in "$OPTIONAL_DIR"/*.sh; do
    script_name=$(basename "$script" .sh)
    title=$(get_title "$script")
    description=$(get_description "$script")

    if [[ -z "$title" ]]; then
        title=$(process_script_name "$script_name")
    fi

    add_app "$app_name" "${description:-$title}"
done

# Display options using gum choose
selected_apps=$(gum choose "${apps[@]}" --no-limit --height 7 --header "Select optional apps")

# Process each selected app
for app in $selected_apps; do
    script_path="$OPTIONAL_DIR/app-${app,,}.sh"
    if [[ ! -f "$script_path" ]]; then
        script_path="$OPTIONAL_DIR/${app}.sh"
    fi
    if [[ -f "$script_path" ]]; then
        clear
        echo "Running $script_path"
        source "$script_path"        
    else
        echo "Script for $app not found."
    fi
done
