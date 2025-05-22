[200~#!/bin/bash

# The commit message is passed as the first argument
commit_msg_file="$1"
commit_msg=$(cat "$commit_msg_file")

# Extract the subject line (first line)
subject_line=$(echo "$commit_msg" | head -n 1)

# --- Define your rules here ---

# Rule 1: Subject line must not be empty
if [[ -z "$subject_line" ]]; then
    echo "Error: Commit message subject line cannot be empty."
    exit 1
fi

# Rule 2: Subject line should not end with a period
if [[ "$subject_line" =~ \.$ ]]; then
    echo "Error: Commit message subject line should not end with a period."
    exit 1
fi

# Rule 3: Subject line should be no more than 50 characters (common convention)
if (( ${#subject_line} > 50 )); then
    echo "Error: Commit message subject line is too long (${#subject_line} chars). Max 50 characters recommended."
    exit 1
fi

# Rule 4: Body lines (if present) should be wrapped at 72 characters (common convention)
# skip the subject line and any blank lines
body_lines=$(echo "$commit_msg" | tail -n +2 | sed '/^\s*$/d')
while IFS= read -r line; do
    if (( ${#line} > 72 )); then
        echo "Warning: Body line exceeds 72 characters: '$line'"
        # You might choose to exit 1 here for strictness, or just warn
        # exit 1
    fi
done <<< "$body_lines"

# Rule 5: Require a blank line between subject and body (if body exists)
# Get the second line
second_line=$(echo "$commit_msg" | sed -n '2p')
# Check if there's a body AND the second line is not empty AND there's content after the second line that's not just whitespace
if [[ $(echo "$commit_msg" | wc -l) -gt 1 && -n "$(echo "$commit_msg" | tail -n +2 | sed '/^\s*$/d' | head -n 1)" && -n "$second_line" ]]; then
    echo "Error: A blank line is required between the subject and body of the commit message."
    exit 1
fi

# --- NEW RULES ---

# Rule 6: Subject line should not be just "init" (case-insensitive)
if [[ "$subject_line" =~ ^[Ii][Nn][Ii][Tt]$ ]]; then
    echo "Error: Commit message 'init' is too generic. Please provide a more descriptive message."
    echo "Example: 'feat: Initial project setup' or 'build: Configure initial CI/CD pipeline'."
    exit 1
fi

# Rule 7: Subject line should not be just "Fix bug" (case-insensitive, allows for variations)
# Using a more robust regex to catch "Fix bug", "Fixed bug", "Fix a bug", "Bug fix" etc.
if [[ "$subject_line" =~ ^([Ff]ix(ed)?|[Bb]ug)\s*(a\s*)?[Bb]ug(\s*.*)?$ ]]; then
    echo "Error: Commit message 'Fix bug' is too generic. Please describe the specific bug."
    echo "Example: 'fix: Correct login button not submitting form data' or 'fix(auth): Prevent infinite redirect on logout'."
    exit 1
fi

# You can add more forbidden simple messages here
# Example:
# if [[ "$subject_line" =~ ^(update|changes|refactor)$ ]]; then
#     echo "Error: Commit message '$subject_line' is too generic. Please be more specific."
#     # exit 1
# fi


# If all checks pass
echo "Commit message looks good!"
exit 0
