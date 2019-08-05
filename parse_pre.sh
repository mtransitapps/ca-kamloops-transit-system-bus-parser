#!/bin/bash
source ../commons/commons.sh
echo ">> Pre Parsing...";
echo ">> Pre Parsing > prepare GTFS files...";
rm -r input/gtfs;
unzip input/gtfs.zip -d input/gtfs;
checkResult $? false;
echo ">> Pre Parsing > prepare GTFS files... DONE";
JAVA_FILES_DIR="src/org/mtransit/parser/ca_kamloops_transit_system_bus";
JAVA_STOPS_FILE="$JAVA_FILES_DIR/Stops.java";
echo ">> Pre Parsing > Set Java stops file...";
> $JAVA_STOPS_FILE; # empty file
echo "package org.mtransit.parser.ca_kamloops_transit_system_bus;" >> $JAVA_STOPS_FILE;
echo "" >> $JAVA_STOPS_FILE;
echo "import java.util.HashMap;" >> $JAVA_STOPS_FILE;
echo "" >> $JAVA_STOPS_FILE;
echo "public class Stops {" >> $JAVA_STOPS_FILE;
echo "	public static HashMap<String, String> ALL_STOPS;" >> $JAVA_STOPS_FILE;
echo "	static {" >> $JAVA_STOPS_FILE;
echo "		HashMap<String, String> allStops = new HashMap<String, String>();" >> $JAVA_STOPS_FILE;
awk -F "\"*,\"*" '{print "		allStops.put(\"" $2 "\", \"" $1"\"); // " $3}' input/gtfs/stops.txt >> $JAVA_STOPS_FILE;
checkResult $? false;
echo "		ALL_STOPS = allStops;" >> $JAVA_STOPS_FILE;
echo "	}" >> $JAVA_STOPS_FILE;
echo "}" >> $JAVA_STOPS_FILE;
echo "" >> $JAVA_STOPS_FILE;
echo ">> Pre Parsing > Set Java stops file... DONE";
JAVA_STOPS_FILE2="$JAVA_FILES_DIR/Stops2.java";
echo ">> Pre Parsing > Set Java stops 2 file...";
> $JAVA_STOPS_FILE2; # empty file
echo "package org.mtransit.parser.ca_kamloops_transit_system_bus;" >> $JAVA_STOPS_FILE2;
echo "" >> $JAVA_STOPS_FILE2;
echo "import java.util.HashMap;" >> $JAVA_STOPS_FILE2;
echo "" >> $JAVA_STOPS_FILE2;
echo "public class Stops2 {" >> $JAVA_STOPS_FILE2;
echo "	public static HashMap<String, String> ALL_STOPS2;" >> $JAVA_STOPS_FILE2;
echo "	static {" >> $JAVA_STOPS_FILE2;
echo "		HashMap<String, String> allStops2 = new HashMap<String, String>();" >> $JAVA_STOPS_FILE2;
awk -F "\"*,\"*" '{print "		if (!allStops2.containsKey(\"" $2 "\")) { allStops2.put(\"" $2 "\", \"" $1"\"); } // " $3}' input/gtfs/stops.txt >> $JAVA_STOPS_FILE2;
checkResult $? false;
echo "		ALL_STOPS2 = allStops2;" >> $JAVA_STOPS_FILE2;
echo "	}" >> $JAVA_STOPS_FILE2;
echo "}" >> $JAVA_STOPS_FILE2;
echo "" >> $JAVA_STOPS_FILE2;
echo ">> Pre Parsing > Set Java stops 2 file... DONE";
echo ">> Pre Parsing > Build Java stops file...";
PARSER_DIRECTORY="../parser";
PARSER_BIN="$PARSER_DIRECTORY/bin";
PARSER_CLASSPATH=$(cat "$PARSER_DIRECTORY/classpath");
javac -cp "bin:$PARSER_BIN" -classpath $PARSER_CLASSPATH -d bin $JAVA_FILES_DIR/*.java;
RESULT=$?;
checkResult $RESULT false;
echo ">> Pre Parsing > Build Java stops file... DONE";
echo ">> Pre Parsing... DONE";
exit $RESULT;