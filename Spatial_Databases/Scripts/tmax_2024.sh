for dir in /Users/devikakakkar/Downloads/prism_2024_tmax/unzipped; do  #Change the path to your file path
    echo "$dir"
    IFS='/' # space is set as delimiter
    #read -ra ADDR <<< "$dir" # str is read into an array as tokens separated by IFS
    #i="${ADDR[-1]}"
    table_name="tmax2024"   #change the table name to match your variable and year
    echo "Checking if table $table_name exists in the database..."

    # Use psql to check if the table exists and handle the empty result
    table_exists=$(psql -U postgres -d postgres -t -c "SELECT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = '$table_name');")
    table_exists="${table_exists// /}"  # Remove whitespace

    if [ -n "$table_exists" ] && [ "$table_exists" = "t" ]; then
        echo "Table $table_name already exists. Skipping raster2pgsql command."
    else
        cmd1="/Applications/Postgres.app/Contents/Versions/latest/bin/raster2pgsql -d -I -C -M -F -t 1000x1000 -s 4269 $dir/*.bil $table_name | psql -U postgres -d postgres"
        echo "$cmd1"
        eval "$cmd1"
    fi
done
