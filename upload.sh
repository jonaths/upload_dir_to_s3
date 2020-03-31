#!/bin/bash

# where to read the files from
target_dir="files"
# the profile in ~/.aws which contains the credantials
aws_profile="profile"
# the bucket name (must exist)
aws_bucket_name="bucket.name.com"
# where to store the files within the bucket (no trailing /)
aws_path="A/PATH"

# uses a clean folder to copy sanitized file names
rm -rf clean/*.*
cp -r $target_dir/*.* clean
# uses detox library to sanitize filenames in clean
detox "clean/"

echo "Reading "$target_dir...

for filename in clean/*; do
    timestamp=(date +"%T")

    echo "==="

    filename_only="${filename##*/}"
    echo "filename_only: $filename_only"

    file_extension="${filename_only##*.}"
    echo "file_extension: $file_extension"

    final_name=$( date +%s )_$filename_only
    echo "final_name: $final_name"

    aws s3 cp $filename s3://$aws_bucket_name/$aws_path/$final_name --profile $aws_profile
done
