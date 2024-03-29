#!/bin/bash

# TODO: !!! [ ] Clean formatting, remove curl output
#        !! [ ] Loop program
#         ! [ ] Pleasant color scheme
#         ! [ ] Menu selection for models, system msgs, prompt defaults;
#                        maybe intervals for temperature + token length

export OPENAI_API_KEY="YOUR_API_KEY_HERE" # place your key here or in your preferred config file

# Model Settings Prompts
read -e -r -p "Enter MODEL version: " -i "gpt-4-turbo-preview" MODEL # e.g. "gpt-4-0125-preview" or "gpt-4-turbo-preview"
read -e -r -p "Enter SYSTEM_MSG: " -i "You are a helpful assistant, well-versed in all modern technical skills and industries." SYSTEM_MSG
PROMPT=${1:-$(read -e -r -p "Enter PROMPT: " REPLY; echo $REPLY)} # get prompt if not given as argument
read -e -p "Enter TEMPERATURE 0.0-2.0 [0.333]: " -i 0.333 TEMPERATURE # variance in responses
read -e -p "Enter MAX_TOKEN_LENGTH 1-4095 [1024]: " -i 1024 MAX_TOKEN_LENGTH # max is roughly 3000 words, about 6 pages of text

# API Defaults
TOP_P=1
FREQUENCY_PENALTY=0.5
PRESENCE_PENALTY=0.5

# Build payload and send to API to generate
OUTPUT=$(curl https://api.openai.com/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${OPENAI_API_KEY}" \
  -d '{
  "model": "'"${MODEL}"'",
  "messages": [
    {
  	  "role": "system",
  	  "content": "'"${SYSTEM_MSG}"'"
    },
    {
  	  "role": "user",
  	  "content": "'"${PROMPT}"'"
    }
  ],
  "temperature": '"${TEMPERATURE}"',
  "max_tokens": '"${MAX_TOKEN_LENGTH}"',
  "top_p": '"${TOP_P}"',
  "frequency_penalty": '"${FREQUENCY_PENALTY}"',
  "presence_penalty": '"${PRESENCE_PENALTY}"'
}')

# Extract text from the response
OUTPUT=$(echo "$OUTPUT" | jq-win64.exe -r '.choices[].message.content') # change `jq-win64.exe` to `jq` if on Unix systems
echo "$OUTPUT" # finally print the response
