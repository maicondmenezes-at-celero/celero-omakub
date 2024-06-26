# Function to display the header
function display_header {
    clear
    term_width=$(tput cols)
    header="OMAKUB Install Process"
    printf "%*s\n" $(((${#header}+$term_width)/2)) "$header" | sed 's/ /_/g'
    printf "| Executing Script: $current_script\n"
    printf "%*s\n" $term_width "" | tr " " "_"
}

# Function to display the body
function display_body {
    local script="$1"
    term_height=$(tput lines)
    body_height=$((term_height - 8))
    printf "|%-${body_height}s|\n" "Script Output: $script"
}

# Function to display the footer
function display_footer {
    term_width=$(tput cols)
    term_height=$(tput lines)
    body_height=$((term_height - 8))

    # Display Progress Bar
    progress=$((executed_scripts * 100 / total_scripts))
    progress_bar=$(printf "%-${progress}s" "#" | tr " " "#")
    empty_space=$((100 - progress))
    empty_bar=$(printf "%-${empty_space}s")

    # Display Progress Numbers
    progress_numbers=$(printf "%02d/%02d" $executed_scripts $total_scripts)

    # Calculate elapsed time
    current_time=$(date +%s)
    elapsed=$((current_time - start_time))
    minutes=$((elapsed / 60))
    seconds=$((elapsed % 60))
    timer=$(printf "%02d:%02d" $minutes $seconds)

    # Display Footer
    printf "%*s\n" $term_width "" | tr " " "_"
    printf "| Progress: [%-100s] | %s | %s |\n" "$progress_bar$empty_bar" "$progress_numbers" "$timer"
    printf "%*s\n" $term_width "" | tr " " "_"
}

# Function to display the signature
function display_signature {
    term_height=$(tput lines)
    printf "%*s\n" $term_height ""
    echo "Author: Maicon de Menezes, Source: https://github.com/maicondmenezes/omakub"
}
