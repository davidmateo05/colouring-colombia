#!/usr/bin/env bash

## Comments:
## Is dynamics_has_demolished_buildings = TRUE sufficient to prevent buildings being loaded? - No
## Lets mark them, then see if there even are any
## Describe these changes in PR and ask for comment if the bool is sufficient

## Prerequisites:
## - Make geometries table have coordinates (load_coordinates.sh) - DONE
## - <mastermap download>= release_geometries
  
###############
### CHECK 1 ###
###############

# for building in buildings

  # if building.TOID not in new release_geometries
    # buildings.dynamics_has_demolished_buildings = TRUE

###############
### CHECK 2 ###
###############

# for geometry in geometries

  # if geometry.TOID not in builings
    # Add TOID to temp table called new_geometries

psql -c "CREATE TABLE new_geometries (
        geometry_id serial PRIMARY KEY,
        source_id varchar(30),
        geometry_geom geometry(GEOMETRY, 3857),
        longitude float,
        latitude float
);"
psql -c "INSERT INTO new_geometries *
            SELECT *
            FROM geometries
            WHERE source_id NOT IN ( SELECT ref_toid FROM buildings);"
    
  # secondarily, if building.coordinates <10m away from any new_geometry.coordinates
    # older_building.dynamics_has_demolished_buildings = TRUE
    # link new_geometry TOID in the geometries table to old building and delete duplicate building we just created for new_geometry