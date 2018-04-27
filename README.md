# matlab_scripts_ecomapper

This repo contains scripts I wrote for processing .log files
coming from our EcoMapper AUV (which is basically an Iver2).
These have last been tested and adapted for Matlab R2018a pre-release.

## plotting all data from several missions, x: time, y: depth, color: sensor
To map/plot all data from all EcoMapper missions, use
`map_all.m` / `plot_all.m`
which will collect data from all missions in the specified folder, 
and plot 2D and 3D figures (plot_all) or a top-down view (map_all).
E.g. to plot all sensor data from one day at the Puddingstone reservoir:
```
plot_all('~/data_em/puddingstone_20180419');
map_all('~/data_em/puddingstone_20180419');
```

## plotting a single sensor from several missions, x: time, y: depth, color: sensor
To map/plot one type of data from all EcoMapper missions, use 
`map_data_from_ecomapper_by_type` / `plot_em_by_type`
E.g. to plot only Chlorophyll data from one day at Puddingstone:
```
plot_em_by_type('chl','~/data_em/puddingstone_20180419')
```

## plotting all data for a single mission, x: time, y: depth, color: sensor
To map/plot one type of data for one day of EM missions, 
EITHER use `map_data_from_ecomapper_by_type_and_date` / `plot_em_type_date`
or use `map_data_from_ecomapper_by_type` / `plot_em_by_type` / `map_all` / `plot_all`
and change the data_prefix_path to the specific log file.
(Haven't tested this in a while.. :) )

## creating interpolated bathymetry plots, x: longitude, y: latitude, color: depth
To create an interpolated data plot, run
`map_interpolated_data_from_ecomapper_by_type` using any data type, for example `water_depth`:
```
map_interpolated_data_from_ecomapper_by_type('water_depth','~/data_em/puddingstone_20180419')
```

## non-interpolated top-down views
Examples:
```
map_data_from_ecomapper_by_type('chl','','~/data_em/puddingstone_20180419')
map_data_from_ecomapper_by_type_and_date('chl',19,4,2018,'','~/data_em');
```

## notes
* all the mapping scripts will use the mapping toolbox, if available, to plot on top of a map
  (last tested for Matlab 2012)
* The following scripts can also be used interactively - they will open a dialog window where you can select the folder that contains the log files to be plotted:
`plot_all*`, `map_all`, `plot_em_by_type*`, `curtainplot_sensors_subset*`

