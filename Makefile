##
# Compiles the API into `./build/ak-daemon`
CC=`which npx`
PLATFORM=`printf 'const os = require("os");console.log(os.platform())' | node`
ARCH=`printf 'const os = require("os");console.log(os.arch())' | node`
TARGET=-t node18-$(PLATFORM)-$(ARCH)
OUTPUT=./build/ak-daemon
SOURCE=./api/index.js
CFLAGS=pkg

all:
	$(CC) $(CFLAGS) $(TARGET) --output $(OUTPUT) $(SOURCE)
