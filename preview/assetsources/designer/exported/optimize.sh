#!/bin/sh
# requires svgo: brew install svgo
for f in *.svg; do 
	echo $f"..."; 
	svgo --enable={sortAttrs} --multipass $f -o - | sed 's/svg /svg width="140" height="140" /g' > "optimized/${f}"

# copy to target dir
#	cp "optimized/${f}" 	
done