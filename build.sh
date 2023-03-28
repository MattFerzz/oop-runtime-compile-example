#!/bin/bash

if [ $# -ne 1 ]; then
  echo "Usage: $0 <input-file>"
  exit 1
fi

input_file="$1"

if [ ! -f "$input_file" ]; then
  echo "Input file $input_file not found"
  exit 1
fi

text=$(cat "$input_file")

encoded_text=$(echo "$text" | base64)

# generate the shell script that runs the ruby script with the encoded text as a parameter
cat <<EOF >run.sh
#!/bin/bash
# an awful but needed script to open the default terminal emulator
for terminal in "\$TERMINAL" x-terminal-emulator mate-terminal gnome-terminal terminator xfce4-terminal termite lxterminal terminology st qterminal lilyterm tilix terminix konsole kitty guake tilda alacritty hyper wezterm urxvt rxvt termit Eterm aterm uxterm xterm roxterm ; do
  if command -v "\$terminal" > /dev/null 2>&1; then
    exec "\$terminal" -e "tail -f console.txt" > /dev/null 2>&1 &
    break
  fi
done

\$(echo "$encoded_text" | base64 -d > /tmp/source.rb)
irb -r /tmp/source.rb
EOF

# make script executable
chmod +x run.sh
