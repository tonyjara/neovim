#!/bin/bash
SECRET=$(security find-generic-password -a "neovim" -s "chatgpt" -w)
echo "$SECRET"
