# version element is prefixed by 4 spaces as this corresponds to the project version and ignores e.g. parent versions
cat $POMPATH/pom.xml | grep "^    <version>.*</version>" | head -1 | awk -F'[><]' '{print $3}'
